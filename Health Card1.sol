// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract HealthCard {
    struct Prescription {
        string prescriptionData;
    }

    struct Patient {
        string name;
        uint age;
        string bloodType;
        string medicalCondition;
        mapping(address => Prescription[]) doctorPrescriptions;
    }

    mapping(address => Patient) public patients;

    event PatientCreated(address indexed patientAddress, string name);
    event PrescriptionAdded(address indexed patientAddress, address indexed doctorAddress, string prescription);

    function createPatient(
        string memory _name,
        uint _age,
        string memory _bloodType,
        string memory _medicalCondition
    ) public {
        Patient storage newPatient = patients[msg.sender];
        newPatient.name = _name;
        newPatient.age = _age;
        newPatient.bloodType = _bloodType;
        newPatient.medicalCondition = _medicalCondition;

        emit PatientCreated(msg.sender, _name);
    }

    function addPrescription(address patientAddress, string memory prescription) public {
        Patient storage patient = patients[patientAddress];
        patient.doctorPrescriptions[msg.sender].push(Prescription(prescription));

        emit PrescriptionAdded(patientAddress, msg.sender, prescription);
    }

    function getPatient(address patientAddress) public view returns (
        string memory name,
        uint age,
        string memory bloodType,
        string memory medicalCondition
    ) {
        Patient storage patient = patients[patientAddress];

        return (
            patient.name,
            patient.age,
            patient.bloodType,
            patient.medicalCondition
        );
    }

    function getPrescriptions(address patientAddress, address doctorAddress) public view returns (string[] memory) {
        Prescription[] storage prescriptions = patients[patientAddress].doctorPrescriptions[doctorAddress];
        string[] memory result = new string[](prescriptions.length);

        for (uint i = 0; i < prescriptions.length; i++) {
            result[i] = prescriptions[i].prescriptionData;
        }

        return result;
    }
}
