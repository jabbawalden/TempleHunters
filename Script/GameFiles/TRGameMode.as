import PlayerFiles.TRCamera;
import GameFiles.TREvents;
import PlayerFiles.TRMainCharacter;

class ATRGameMode : AGameModeBase
{
    UPROPERTY()
    TArray<APlayerStart> PlayerStartArray;

    UPROPERTY()
    int SpawnIndexTag;

    TArray<ATRCamera> Camera;

    UPROPERTY()
    TArray<ATRMainCharacter> MainCharacters;

    UPROPERTY()
    TSubclassOf<AActor> Player1BP;
    UPROPERTY()
    TSubclassOf<AActor> Player2BP;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        ATRCamera::GetAll(Camera);
        GetPlayerStarts();
        SetAndSpawnPlayers();
    }

    UFUNCTION()
    void GetPlayerStarts()
    {
        APlayerStart::GetAll(PlayerStartArray);
    }

    UFUNCTION()
    void SetAndSpawnPlayers()
    {
        APlayerController PlayerController2 = Gameplay::CreatePlayer(1); 

        ATRMainCharacter::GetAll(MainCharacters);

        for (int i = 0; i < MainCharacters.Num(); i++)
        {
            if (MainCharacters[i].Class == Player1BP)
            {
                APlayerController PlayerController1 = Gameplay::GetPlayerController(0); 
                PlayerController1.Possess(MainCharacters[i]);
                Print("Player 1 possessed", 5.f);
            }
            else if (MainCharacters[i].Class == Player2BP)
            {
                PlayerController2.Possess(MainCharacters[i]); 
                Print("Player 2 possessed", 5.f);              
            }
        }

        Camera[0].SetCharacterReferences(); 

        for (int i = 0; i < MainCharacters.Num(); i++)
        {
            APlayerController PlayerController = Gameplay::GetPlayerController(i);
            if (PlayerController != nullptr)
            {
                PlayerController.SetViewTargetWithBlend(Camera[0], 0.f);
            }

        }

    }
}