import PlayerFiles.TRMainCharacter;
import WorldFiles.TREnvironmentPiece;

class ATRCamera : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USpringArmComponent SpringArm;
    default SpringArm.TargetArmLength = 500.f;

    UPROPERTY(DefaultComponent, Attach = SpringArm)
    UCameraComponent Camera;

    TArray<ATRMainCharacter> Characters;

    TArray<ATREnvironmentPiece> EnvPieces;

    UPROPERTY()
    float InterpSpeed = 0.9f;
    
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {

    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetSpringArmLength(DeltaSeconds);
        SetCameraLocation(DeltaSeconds);
        EnvironmentCheckCharOne();
        EnvironmentCheckCharTwo();
    }

    //called by Game Mode
    UFUNCTION()
    void SetCharacterReferences()
    {
        ATRMainCharacter::GetAll(Characters);
       
        for (int i = 0; i < Characters.Num(); i++)
        {
            Characters[i].SetCamRef(this); 
        }

    }

    UFUNCTION()
    void SetSpringArmLength(float DeltaSeconds)
    {
        float CurrentLength = Characters[0].DistanceFromOther * 0.85f + 750.f; 
        float InterpLength = FMath::FInterpTo(SpringArm.TargetArmLength, CurrentLength, DeltaSeconds, InterpSpeed);
        SpringArm.TargetArmLength = InterpLength;
    }

    UFUNCTION()
    void SetCameraLocation(float DeltaSeconds)
    {
        FVector AddedLocs = Characters[0].GetActorLocation() + Characters[1].GetActorLocation();
        AddedLocs /= 2;
        float XLocInterp = FMath::FInterpTo(GetActorLocation().X, AddedLocs.X, DeltaSeconds, InterpSpeed);
        float YLocInterp = FMath::FInterpTo(GetActorLocation().Y, AddedLocs.Y, DeltaSeconds, InterpSpeed);
        float ZLocInterp = FMath::FInterpTo(GetActorLocation().Z, AddedLocs.Z, DeltaSeconds, InterpSpeed);
        SetActorLocation(FVector(XLocInterp, YLocInterp, ZLocInterp)); 
    }

    UFUNCTION()
    void EnvironmentCheckCharOne()
    {
        TArray<AActor> IgnoredActors;
		IgnoredActors.Add(this);
        FHitResult Hit;
        
		FVector StartLocation = Camera.GetWorldLocation();
		FVector EndLocation = Characters[0].GetActorLocation();

        if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
        {
            ATREnvironmentPiece ActorHit = Cast<ATREnvironmentPiece>(Hit.Actor); 

            if (ActorHit != nullptr)
            {
                if (!EnvPieces.Contains(ActorHit))
                {
                    EnvPieces.Add(ActorHit); 
                }
                Print("Set" + ActorHit.Name + " to transluscent", 0.f);
            }
        }
        else
        {

        }
    }

    UFUNCTION()
    void EnvironmentCheckCharTwo()
    {
        TArray<AActor> IgnoredActors;
		IgnoredActors.Add(this);
        FHitResult Hit;
        
		FVector StartLocation = Camera.GetWorldLocation();
		FVector EndLocation = Characters[1].GetActorLocation();

        if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
        {
            ATREnvironmentPiece ActorHit = Cast<ATREnvironmentPiece>(Hit.Actor); 

            if (ActorHit != nullptr)
            {
                if (!EnvPieces.Contains(ActorHit))
                {
                    EnvPieces.Add(ActorHit); 
                }

                Print("Set" + ActorHit.Name + " to transluscent", 0.f);
            }
            
        }
        else
        {
            
        }
    }
}