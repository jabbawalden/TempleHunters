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
    float EndZLoc = 400.f;

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

    UFUNCTION()
    void ActivateSequence()
    {
        bActivated = true;
        Print("SEQUENCE ACTIVATED", 5.f);
    }

    UFUNCTION()
    void MoveSequence()
    {
        float DistanceToEnd = EndLocation.Z - GetActorLocation().Z;
        Print("" + DistanceToEnd, 0.f);

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