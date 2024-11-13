using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

public class ControllAR : MonoBehaviour
{   
    [SerializeField]
    private GameObject parentObject;
    private GameObject[] childObject;
    private ARTrackedImageManager _imageManager;

    // MonoBehaviorの状態によって呼び出されるメソッド
    private void Start(){
        _imageManager = FindObjectOfType<ARTrackedImageManager>();
        int childCount = parentObject.transform.childCount;
        childObject = new GameObject[childCount];

        for(int i = 0; i < childCount; i++){
            childObject[i] = parentObject.transform.GetChild(i).gameObject;
        }

        //_imageManager.trackedImagesChanged＝imageTrackingをするたびに呼び出されるメソッド
        // 呼び出された際に実行するメソッドを追加
        _imageManager.trackedImagesChanged += OntrackedImageChanged;
    }

    private void OnDisable(){
        _imageManager.trackedImagesChanged -= OntrackedImageChanged;
    }

    private void OntrackedImageChanged(ARTrackedImagesChangedEventArgs eventArgs){
        foreach (var trackedImage in eventArgs.added){
            Debug.Log("Image added: " + trackedImage.referenceImage.name);
            ActiveAR(trackedImage);
        }

        foreach (var trackedImage in eventArgs.updated){
            Debug.Log("Image updated: " + trackedImage.referenceImage.name);
            ActiveAR(trackedImage);
        }
    }   


    // TrackImage
    public void ActiveAR(ARTrackedImage trackedImage){
        GameObject referenceObject = GameObject.Find("Scripts");
        DisplayObjectNumber reference = referenceObject.GetComponent<DisplayObjectNumber>();
        int index = reference.displayObjectNumber;

        if(trackedImage.trackingState == TrackingState.Tracking){
            childObject[index].SetActive(true);
            parentObject.transform.position = trackedImage.transform.position;
            parentObject.transform.rotation = trackedImage.transform.rotation;
        }else{
            childObject[index].SetActive(false);
        }
    }
}
