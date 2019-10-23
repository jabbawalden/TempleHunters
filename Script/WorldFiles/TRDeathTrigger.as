import PlayerFiles.TRMainCharacter;
class ATRDeathTrigger : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent TriggerComp;
    default TriggerComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap); 
    
    UPROPERTY()
    TSubclassOf<AActor> P1Class;
    UPROPERTY()
    TSubclassOf<AActor> P2Class;

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
        if (OtherActor.Class == P1Class || OtherActor.Class == P2Class)
        {
            ATRMainCharacter MainCharacter = Cast<ATRMainCharacter>(OtherActor);
            
            if (MainCharacter != nullptr)
            {
                MainCharacter.ResetPlayer(); 
            }
        }

    }
}