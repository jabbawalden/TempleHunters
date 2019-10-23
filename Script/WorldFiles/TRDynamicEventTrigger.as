import GameFiles.TREvents;

class ATRDynamicEventTrigger : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent TriggerComp;
    default TriggerComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap); 

    FDynamicEventCall EventDynamicCall;

    UPROPERTY()
    TSubclassOf<AActor> ActorClass;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {   
        TriggerComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
    }

     UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Class == ActorClass)
        {
            EventDynamicCall.Broadcast();
        }
    }
}