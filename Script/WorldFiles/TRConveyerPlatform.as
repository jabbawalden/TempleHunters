import WorldFiles.TRDynamicEventTrigger;

class ATRConveyerPlatform : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;

    UPROPERTY()
    TArray<AActor> Locations;

    UPROPERTY()
    ATRDynamicEventTrigger DynamicEventTrigger;

    UPROPERTY()
    int TargetIndex = 0;

    float Distance;
    float MinDistance = 15.f;

    float MovementSpeedStart = 100.f;
    float MovementSpeedMain = 250.f;
    float MovementSpeedCurrent;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        //initialize speed
        MovementSpeedCurrent = MovementSpeedStart;
    }

    UFUNCTION(BlueprintOverride)
    void Tick (float DeltaSeconds)
    {
        DistanceToTarget();
        MoveActorToLoc(DeltaSeconds); 
    }

    UFUNCTION()
    void MoveActorToLoc(float DeltaSeconds)
    {
        //if distance greater than mindistance, move
        if (Distance > MinDistance)
        {
            FVector CurrentLoc = ActorLocation;
            FVector MoveDirection = Locations[TargetIndex].GetActorLocation() - CurrentLoc;
            MoveDirection.Normalize(); 
            FVector NextLoc = CurrentLoc + MoveDirection * MovementSpeedCurrent * DeltaSeconds;
            SetActorLocation(NextLoc);  
        }
        else //if less, we have reached location, set new location OR destroy if last loc reached
        {
            if (TargetIndex < Locations.Num() - 1)
            {
                SetNextTarget();
            }
            else
            {
                this.DestroyActor(); 
            }

        }
    }

    //called by spawner
    UFUNCTION()
    void SetLocations(TArray<AActor> LocsToPass)
    {
        for (int i = 0; i < LocsToPass.Num(); i++)
        {
            Locations.Add(LocsToPass[i]); 
            
        }
    }

    //called by spawner
    UFUNCTION()
    void SetDynamicEvent(ATRDynamicEventTrigger EventTrigger)
    {
        DynamicEventTrigger = EventTrigger; 
        if (DynamicEventTrigger != nullptr)
        {
            DynamicEventTrigger.EventDynamicCall.AddUFunction(this, n"SetMainMovementSpeed");
        }
    }

    //called in move function
    UFUNCTION()
    void SetNextTarget()
    {
        TargetIndex++;
    }

    //checks distance to next target
    UFUNCTION()
    void DistanceToTarget()
    {
        Distance = GetDistanceTo(Locations[TargetIndex]); 
        Print("Our distance is: " + Distance, 0.f);
    }

    //assigned to event dynamic call - trigger will broadcast event when overlapping with us
    UFUNCTION()
    void SetMainMovementSpeed()
    {
        MovementSpeedCurrent = MovementSpeedMain;
    }

}