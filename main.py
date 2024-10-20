import cv2
import mediapipe as mp
import time
import TrackingModule as TM

def main():
    pTime = 0
    cTime = 0
    detector = TM.handDetector()
    cap = cv2.VideoCapture(detector.cam)

    frame_width, frame_height = 640, 480

    while True:
        success, img = cap.read()
        if not success:
            print("Failed to capture image")
            break
        
        # Resize the image to improve processing speed
        img = cv2.flip(img, cv2.ROTATE_180)
        img = cv2.resize(img, (frame_width, frame_height))

        # Find hands and positions
        img = detector.findHands(img, draw=False)
        lmList = detector.findPosition(img, draw=False)

        if len(lmList) != 0:
            print(lmList[4])

        cTime = time.time()
        fps = 1 / (cTime - pTime)
        pTime = cTime

        # Display FPS on the image (optional)
        cv2.putText(img, f'FPS: {int(fps)}', (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 255), 2)

        cv2.imshow("Image", img)

        # Introduce a slight delay for frame display
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()