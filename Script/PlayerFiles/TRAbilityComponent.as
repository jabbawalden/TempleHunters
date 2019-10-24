class UTRAbilityComponent : UActorComponent
{
    float DashSpeed = 1635.f;
    float NewDashTime;
    float DashRate = 0.3f;
    bool bIsDashing;
    bool bIsFacingWall;

    float JumpForce = 125000.f;
    float SlamForce = 210000.f;
    bool bCanSlam;
    bool bIsSlamming;

    UPROPERTY()
    UCharacterMovementComponent CharacterMovementRef;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        CharacterMovementRef = UCharacterMovementComponent::Get(Owner);
    }

    UFUNCTION()
    void PlayerJump()
    {
        //Print("Player Jump", 5.f);
        FVector JumpDirection = FVector(0,0,JumpForce);
        CharacterMovementRef.AddImpulse(JumpDirection);
    }

    UFUNCTION()
    void PlayerSlam()
    {
        if (bCanSlam) 
        {
            //Print("Player Slam", 5.f);
            FVector SlamDirection = FVector(0,0,-SlamForce);
            CharacterMovementRef.AddImpulse(SlamDirection);
            bIsSlamming = true;
        }
    }

    UFUNCTION()
    void PlayerDashOn()
    {
        //Print("Player Dash On", 5.f);
        bIsDashing = true;
        NewDashTime = Gameplay::GetTimeSeconds() + DashRate;
    }

    UFUNCTION()
    void PlayerDashOff()
    {
        //Print("Player Dash Off", 5.f);
        bIsDashing = false;
    }

    UFUNCTION(BlueprintOverride)
    void Tick (float DeltaSeconds)
    {
        FacingWallCheck();

        //Print("Slam Bool is: " + bCanSlam, 0.f);

        if (bIsDashing && NewDashTime > Gameplay::GetTimeSeconds() && !bIsFacingWall)
        {
            DashMove(DeltaSeconds);
        }
        else 
        {
            bIsDashing = false;
        }
    }

    UFUNCTION()
    void DashMove(float DeltaSeconds)
    {
        FVector CurrentLocation = GetOwner().GetActorLocation();
        FVector ForwardLocation = GetOwner().GetActorForwardVector() * DashSpeed * DeltaSeconds;
        FVector NewLocation = CurrentLocation + ForwardLocation;
        GetOwner().SetActorLocation(NewLocation);
    }

    UFUNCTION()
    void FacingWallCheck()
    {
        TArray<AActor> IgnoredActors;
		IgnoredActors.Add(Owner);
        FHitResult Hit;
        
		FVector StartLocation = GetOwner().ActorLocation;
		FVector EndLocation = GetOwner().ActorLocation + GetOwner().GetActorForwardVector() * 50.f;

        if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
        {
            bIsFacingWall = true;
            //Print("Facing Wall is: " + bIsFacingWall, 0.f);
        }
        else
        {
            bIsFacingWall = false;
            //Print("Facing Wall is: " + bIsFacingWall, 0.f);
        }
    }
}