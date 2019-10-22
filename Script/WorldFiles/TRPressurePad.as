import GameFiles.TREvents;
import PlayerFiles.TRSlamImpact;
import PlayerFiles.TRMainCharacter;

enum EPressurePadType {Wall, Ground}

class ATRPressurePad : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;

    //interactable object needs to add it's function to this event, and needs reference to this pad.
    FActivatePressurePad EventActivatePressurePad; 
    UPROPERTY()
    EPressurePadType PressurePadType;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        BoxComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (PressurePadType == EPressurePadType::Ground)
        {
            ATRSlamImpact SlamActor = Cast<ATRSlamImpact>(OtherActor);
        
            if (SlamActor != nullptr)
            {
                EventActivatePressurePad.Broadcast();
                Print("Pressure Pad Event broadcasted", 5.f);
            }
        }
        else if (PressurePadType == EPressurePadType::Wall)
        {
            ATRMainCharacter MainCharacter = Cast<ATRMainCharacter>(OtherActor);

            if (MainCharacter != nullptr)
            {
                UTRAbilityComponent AbilityCompRef = UTRAbilityComponent::Get(MainCharacter);
                if (AbilityCompRef.bIsDashing)
                {
                    EventActivatePressurePad.Broadcast();
                }
            }
        }


        //check if player has a certain component OR tag OR index... then broadcast event
        // if (OtherActor.GetComponentByClass(CLASSREFERENCE))
        // {
        //     EventActivatePressurePad.Broadcast();
        // }
    }
}