import PlayerFiles.TRAbilityComponent;
import PlayerFiles.TRSlamImpact;

class ATRMainCharacter : ACharacter
{
    UPROPERTY(DefaultComponent)
    UStaticMeshComponent MeshCompDebug;

    UPROPERTY(DefaultComponent, Attach = MeshCompDebug)
    UStaticMeshComponent MeshIdentifier;

    UPROPERTY(DefaultComponent)
    UInputComponent InputComp;

    UPROPERTY()
    UCharacterMovementComponent CharacterMovementRef;

    UPROPERTY()
    AActor CameraReference;

    UPROPERTY()
    TArray<ATRMainCharacter> OtherPlayer; 

    UPROPERTY(DefaultComponent)
    UTRAbilityComponent AbilityComp;

    UPROPERTY()
    TSubclassOf<AActor> SlamImpactClass;
    AActor SlamImpact;

    APlayerController PlayerController;

    UPROPERTY()
    float DistanceFromOther;

    UPROPERTY()
    float GroundTraceDistance = -93.f;
    UPROPERTY()
    float SlamTraceDistance = -275.f;

    UPROPERTY()
    float DefaultMovementSensitivity = 0.7f;

    float MovementSensitivity = DefaultMovementSensitivity;

    UPROPERTY()
    bool bIsGrounded;

    bool CanMove = false;

    float NewTime = 4.f;

    UPROPERTY()
    int PlayerIndex;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        //Get all characters
        ATRMainCharacter::GetAll(OtherPlayer);
        
        //get and set CharacterMovement air control
        CharacterMovementRef = UCharacterMovementComponent::Get(this);
        if (CharacterMovementRef != nullptr)
        {
            CharacterMovementRef.AirControl = 0.3f;
        }

        //remove self from character array
        for (int i = 0; i < OtherPlayer.Num(); i++)
        {
            if (OtherPlayer[i] == this)
            {
                OtherPlayer.RemoveAt(i); 
            }
        }

        PlayerInputSetup();

        PlayerController = Gameplay::GetPlayerController(PlayerIndex);
        
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        FindDistance();
        float Divider = 10;
        GroundCheck();
        SlamCheck();
        //SetActorRotation(FRotator(0, GetVelocity().Y / Divider, GetVelocity().Z / Divider)); 
    }

    UFUNCTION()
    void PlayerInputSetup()
    {
        InputComp.BindAxis(n"MoveForward", FInputAxisHandlerDynamicSignature(this, n"MovePForward"));
        InputComp.BindAxis(n"RotateRight", FInputAxisHandlerDynamicSignature(this, n"MovePRight"));
        InputComp.BindAction(n"SpecialAbility", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"OnSpecialAbility"));
        InputComp.BindAction(n"SpecialAbility", EInputEvent::IE_Released, FInputActionHandlerDynamicSignature(this, n"OffSpecialAbility"));
    }


    UFUNCTION()
    void MovePForward(float AxisValue)
    {
        AddMovementInput(CameraReference.GetActorForwardVector(), AxisValue * MovementSensitivity); 
    }

    UFUNCTION()
    void MovePRight(float AxisValue)
    {
        AddMovementInput(CameraReference.GetActorRightVector(), AxisValue * MovementSensitivity); 
    }

    UFUNCTION()
    void OnSpecialAbility(FKey Key)
    {
        //if player index 0 or 1, get a different function from the ability component
        if (PlayerIndex == 0)
        {
            if (bIsGrounded)
                AbilityComp.PlayerJump();
        }
        else 
        {
            AbilityComp.PlayerDashOn();
            MovementSensitivity = 0;
            CharacterMovement.GravityScale = 0.f; 
        }
    }

    UFUNCTION()
    void OffSpecialAbility(FKey Key)
    {
        if (PlayerIndex == 0)
        {
            if (!bIsGrounded)
            {
                AbilityComp.PlayerSlam();
            }
        }
        else 
        {
            AbilityComp.PlayerDashOff();
            MovementSensitivity = DefaultMovementSensitivity;
            CharacterMovement.GravityScale = 1.f; 
        }
    }

    UFUNCTION()
    void SetCamRef(AActor CamRef)
    {
        CameraReference = CamRef;
    }

    UFUNCTION()
    void FindDistance()
    {
        DistanceFromOther = GetDistanceTo(OtherPlayer[0]); 
    }

    UFUNCTION()
    void GroundCheck()
    {
        /* We create this array in order to add Actors to be ignored */
		TArray<AActor> IgnoredActors;
        //use if component
		// IgnoredActors.Add(GetOwner());
		IgnoredActors.Add(this);

		FVector StartLocation = ActorLocation;
		FVector EndLocation = ActorLocation + (GetActorUpVector() * GroundTraceDistance);

		/* We use this FHitResult to store our line tracing results */
		FHitResult Hit;
		if(System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
		{
			AActor HitActor = Hit.GetActor();

            bIsGrounded = true;
            Print("Grounded = " + bIsGrounded, 0.0f);

            if (AbilityComp.bIsSlamming)
            {
                SlamImpact = SpawnActor(SlamImpactClass, GetActorLocation() + FVector(0,0,-100.f)); 
                Print("Slam completed", 5.f);
                AbilityComp.bIsSlamming = false;
            }

            //Debug to help you visualize the linetrace
			// System::DrawDebugLine(StartLocation, EndLocation, FLinearColor::Green, 5.0f, 2.0f);
		}
        else 
        {
            bIsGrounded = false;
            Print("Grounded = " + bIsGrounded, 0.0f);
        }
    }

    UFUNCTION()
    void SlamCheck()
    {
        TArray<AActor> IgnoredActors;
		IgnoredActors.Add(this);
        FHitResult Hit;
        
		FVector StartLocation = ActorLocation;
		FVector EndLocation = ActorLocation + (GetActorUpVector() * SlamTraceDistance);

        if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
        {
            AbilityComp.bCanSlam = false;
        }
        else
        {
            AbilityComp.bCanSlam = true;
        }
    }
}