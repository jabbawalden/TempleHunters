class ATRCheckPoints : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USceneComponent Player1SpawnLoc;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USceneComponent Player2SpawnLoc;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UBoxComponent BoxTrigger;
    default BoxTrigger.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY()
    TSubclassOf<AActor> P1Class;

    UPROPERTY()
    TSubclassOf<AActor> P2Class;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        BoxTrigger.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap"); 
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        //Check if player 1 or 2 then save accordingly
    }

    UFUNCTION()
    void SavePoints(FVector SaveLocation)
    {   
        //save check point locations to player ondeath start locations
    }

}
