import WorldFiles.TRPressurePad;

class ATRPlatformOutward : AActor
{
    UPROPERTY()
    AActor EndLocationA;

    UPROPERTY()
    AActor StartLocationA;

    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;

    UPROPERTY()
    ATRPressurePad PressurePadRef;

    UPROPERTY()
    float OutSpeed = 8.f;
    UPROPERTY()
    float InSpeed = 1.5f;

    bool bActivated;
    bool bReturning;

    FVector StartPosition; 

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        StartLocationA.SetActorLocation(ActorLocation);

        PressurePadRef.EventActivatePressurePad.AddUFunction(this, n"PushOutSequence");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (bActivated)
        {
            OutMovement();
        }
        else if (bReturning)
        {
            InMovement();
        }
    }

    UFUNCTION()
    void PushOutSequence()
    {
        bActivated = true;
        bReturning = false;
    }

    UFUNCTION()
    void OutMovement()
    {
        float DistanceToEnd = GetDistanceTo(EndLocationA);
        if (DistanceToEnd >= 10.f)
        {
            FVector CurrentLoc = ActorLocation;
            FVector DirectionLoc = EndLocationA.GetActorLocation() - CurrentLoc;
            DirectionLoc.Normalize(); 
            BoxComp.SetWorldLocation(CurrentLoc + DirectionLoc * OutSpeed);
        }
        else if (!bReturning)
        {
            bActivated = false;
            bReturning = true;
        }
    }

    UFUNCTION()
    void InMovement()
    {
        float DistanceToEnd = GetDistanceTo(StartLocationA);
        if (DistanceToEnd >= 10.f)
        {
            FVector CurrentLoc = ActorLocation;
            FVector DirectionLoc = StartLocationA.GetActorLocation() - CurrentLoc;
            DirectionLoc.Normalize(); 
            BoxComp.SetWorldLocation(CurrentLoc + DirectionLoc * InSpeed);
        }
        else 
        {
            bReturning = false;
        }
    }
}