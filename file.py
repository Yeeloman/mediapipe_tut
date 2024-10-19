import cv2
import mediapipe as mp

# Initialize MediaPipe components
mp_face_detection = mp.solutions.face_detection
face_detection = mp_face_detection.FaceDetection(min_detection_confidence=0.2)

# Replace with your IP Webcam URL
webcam_url = "http://192.168.11.101:8080/video"  # Example URL

# Capture video stream
cap = cv2.VideoCapture(webcam_url)

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        print("Failed to grab frame")
        break

    # Convert the frame to RGB (MediaPipe uses RGB images)
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # Process the frame with MediaPipe
    results = face_detection.process(frame_rgb)

    # Log detection results
    if results.detections:
        print(f"Detected {len(results.detections)} faces.")
        for detection in results.detections:
            bboxC = detection.location_data.relative_bounding_box
            ih, iw, _ = frame.shape
            # Draw bounding box around the face
            cv2.rectangle(frame, (int(bboxC.xmin * iw), int(bboxC.ymin * ih)),
                          (int((bboxC.xmin + bboxC.width) * iw), int((bboxC.ymin + bboxC.height) * ih)),
                          (0, 255, 0), 2)

    # Show the frame with detections in a window
    cv2.imshow('IP Webcam Face Detection', frame)

    # Press 'q' to exit the video window
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
print("Video capture ended.")
