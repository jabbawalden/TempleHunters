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

    TArray<ATRMainCharacter> MainCharacters;

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
        // for (int i = 0; i < PlayerStartArray.Num(); i++)
        // {
        //     Gameplay::CreatePlayer(i); 
        //     APlayerController PlayerController = Gameplay::GetPlayerController(i);
        //     PlayerController.SetViewTargetWithBlend(Camera[0], 0.f);

        //     if (PlayerStartArray[i].PlayerStartTag.ToString() != "" + SpawnIndexTag)
        //     {
        //         PlayerStartArray[i].PlayerStartTag.ToString() == "" + i;
        //     }
        // }
        // //example of changing tag
        // // PlayerStartArray[0].PlayerStartTag.ToString() = "Hello"; 

        ATRMainCharacter::GetAll(MainCharacters);
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