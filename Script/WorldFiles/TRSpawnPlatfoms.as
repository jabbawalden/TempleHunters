import WorldFiles.TRConveyerPlatform;
import WorldFiles.TRPressurePad;

class ATRSpawnPlatforms : AActor
{
    UPROPERTY()
    TSubclassOf<AActor> ConveyerPlatform;
    AActor ConveyerPlatformRef;
    ATRConveyerPlatform ConveyerPlatformClass;

    UPROPERTY()
    ATRPressurePad PressurePad;

    bool bCanSpawn;
    float NewTime;

    UPROPERTY()
    float SpawnRate = 7.5f;

    UPROPERTY()
    TArray<AActor> Locations;

    UPROPERTY()
    ATRDynamicEventTrigger DynamicEventTrigger;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        PressurePad.EventActivatePressurePad.AddUFunction(this, n"StartSpawn");
    }

    UFUNCTION(BlueprintOverride)
    void Tick (float DeltaSeconds)
    {
        if (bCanSpawn)
        {
            if (NewTime <= Gameplay::TimeSeconds)
            {
                NewTime = Gameplay::TimeSeconds + SpawnRate;
                ConveyerPlatformRef = SpawnActor(ConveyerPlatform, ActorLocation);
                ConveyerPlatformClass = Cast<ATRConveyerPlatform>(ConveyerPlatformRef);

                if (ConveyerPlatformClass != nullptr)
                {
                    ConveyerPlatformClass.SetLocations(Locations); 
                    ConveyerPlatformClass.SetDynamicEvent(DynamicEventTrigger);
                }

            }
        }
    }

    UFUNCTION()
    void StartSpawn()
    {
        bCanSpawn = true;
    }

}
