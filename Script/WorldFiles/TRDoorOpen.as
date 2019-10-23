import WorldFiles.TRPressurePad;

class ATRDoorOpen : AActor
{
    UPROPERTY()
    FVector EndLocation;

    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;

    UPROPERTY()
    ATRPressurePad PressurePadRef;

    bool bActivated;

    float MovementSpeed = 10.f;

    UPROPERTY()
    float EndZLoc = 500.f;

    float DistanceToEnd;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        EndLocation = FVector(GetActorLocation().X, GetActorLocation().Y, GetActorLocation().Z + EndZLoc);
        PressurePadRef.EventActivatePressurePad.AddUFunction(this, n"ActivateSequence");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (bActivated)
        {
            MoveSequence();
        }
    }

    //assigned to pressure pad event
    UFUNCTION()
    void ActivateSequence()
    {
        bActivated = true;
        Print("SEQUENCE ACTIVATED", 5.f);
    }

    UFUNCTION()
    void MoveSequence()
    {
        //account for direction in negative and positive
        if (EndZLoc < 0)
        {
            DistanceToEnd = GetActorLocation().Z - EndLocation.Z;
        }
        else if (EndZLoc > 0)
        {
            DistanceToEnd = EndLocation.Z - GetActorLocation().Z;
        }

        if (DistanceToEnd >= 10.f)
        {
            FVector CurrentLoc = ActorLocation;
            FVector DirectionLoc = EndLocation - CurrentLoc;
            DirectionLoc.Normalize(); 
            BoxComp.SetWorldLocation(CurrentLoc + DirectionLoc * MovementSpeed);
        }
        else
        {
            bActivated = false;
        }
    }
}