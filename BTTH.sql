-- Tạo bảng Patients
CREATE TABLE Patients (
    Patient_ID     CHAR(5)      NOT NULL PRIMARY KEY,
    Full_Name      VARCHAR(100) NOT NULL,
    Admission_Time DATETIME     DEFAULT CURRENT_TIMESTAMP
);

-- Tạo bảng Vitals_Logs
CREATE TABLE Vitals_Logs (
    Log_ID         INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Patient_ID     CHAR(5)      NOT NULL REFERENCES Patients(Patient_ID),
    Heart_Rate     INT          NOT NULL CHECK (Heart_Rate > 0),
    Blood_Pressure VARCHAR(20),
    Record_Time    DATETIME     DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_check_patient ON Vitals_Logs(Patient_ID,Record_Time);
CREATE OR REPLACE VIEW ER_Dashboard_View AS
SELECT 
    p.Patient_ID,
    p.Full_Name,
    p.Admission_Time,
    IFNULL(v.Heart_Rate, 'Pending') AS Heart_Rate,
	v.Blood_Pressure,
    CASE 
    WHEN v.Heart_Rate>120 OR v.Heart_Rate<50 THEN 'Critical'
    ELSE 'Stable'
    END AS Urgency_Level
FROM Patients p
LEFT JOIN Vitals_Logs v ON p.Patient_ID = v.Patient_ID;