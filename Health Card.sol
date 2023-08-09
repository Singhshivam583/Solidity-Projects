// SPDX-License-Identifier: GPL-3.0

// pragma solidity >=0.8.2 <0.9.0;

// contract HealthCard {
//     struct Patient {
//         string name;
//         uint age;
//         string bloodType;
//         string medicalCondition;
//         mapping(address => string[]) prescriptions; // Mapping to store doctors' prescriptions
//         address createdBy;
//     }

//     struct Doctor {
//         string name;
//         string specialization;
//     }

//     mapping(address => Patient) public patients;
//     mapping(address => Doctor) public doctors; // Mapping to store doctor details

//     event PatientCreated(address indexed patientAddress, string name);
//     event DoctorAdded(address indexed doctorAddress, string name, string specialization);
//     event PrescriptionAdded(address indexed patientAddress, address indexed doctorAddress, string prescription);

//     function createPatient(string memory _name,uint _age,string memory _bloodType,string memory _medicalCondition) public {
//         Patient memory newPatient =Patient({
//             name: _name,
//             age: _age,
//             bloodType: _bloodType,
//             medicalCondition: _medicalCondition,
//             createdBy: msg.sender
//         });

//         patients[msg.sender] = newPatient;

//         emit PatientCreated(msg.sender, _name);
//     }

//     function addDoctor(address doctorAddress, string memory name, string memory specialization) public {
//         require(msg.sender != doctorAddress, "Doctor cannot add themselves as a doctor");

//         Doctor memory newDoctor = Doctor({
//             name: name,
//             specialization: specialization
//         });

//         doctors[doctorAddress] = newDoctor;

//         emit DoctorAdded(doctorAddress, name, specialization);
//     }

//     function addPrescription(address patientAddress, string memory prescription) public {
//         require(doctors[msg.sender].name != '', "Prescription can only be added by doctors");
//         patients[patientAddress].prescriptions[msg.sender].push(prescription);

//         emit PrescriptionAdded(patientAddress, msg.sender, prescription);
//     }

//     function getPatient(address patientAddress) public view returns (
//         string memory name,
//         uint age,
//         string memory bloodType,
//         string memory medicalCondition,
//         address createdBy
//     ) {
//         Patient memory patient = patients[patientAddress];

//         return (
//             patient.name,
//             patient.age,
//             patient.bloodType,
//             patient.medicalCondition,
//             patient.createdBy
//         );
//     }

//     function getPrescriptions(address patientAddress, address doctorAddress) public view returns (string[] memory) {
//         return patients[patientAddress].prescriptions[doctorAddress];
//     }
// }

pragma solidity ^0.8.0;

contract HealthCard {
    struct Patient {
        string name;
        uint age;
        string bloodType;
        string medicalCondition;
        mapping(address => string[]) prescriptions; // Mapping to store doctors' prescriptions
        address createdBy;
    }

    struct Doctor {
        string name;
        string specialization;
    }

    mapping(address => Patient) public patients;
    mapping(address => Doctor) public doctors; // Mapping to store doctor details

    event PatientCreated(address indexed patientAddress, string name);
    event DoctorAdded(address indexed doctorAddress, string name, string specialization);
    event PrescriptionAdded(address indexed patientAddress, address indexed doctorAddress, string prescription);

    function createPatient(
        string memory _name,
        uint _age,
        string memory _bloodType,
        string memory _medicalCondition
    ) public {
        Patient memory newPatient;
        newPatient.name = _name;
        newPatient.age = _age;
        newPatient.bloodType = _bloodType;
        newPatient.medicalCondition = _medicalCondition;
        newPatient.createdBy = msg.sender;

        patients[msg.sender] = newPatient;

        emit PatientCreated(msg.sender, _name);
    }

    function addDoctor(address doctorAddress, string memory name, string memory specialization) public {
        require(msg.sender != doctorAddress, "Doctor cannot add themselves as a doctor");

        Doctor memory newDoctor;
        newDoctor.name = name;
        newDoctor.specialization = specialization;

        doctors[doctorAddress] = newDoctor;

        emit DoctorAdded(doctorAddress, name, specialization);
    }

    function addPrescription(address patientAddress, string memory prescription) public {
        require(bytes(doctors[msg.sender].name).length != 0, "Prescription can only be added by doctors");
        patients[patientAddress].prescriptions[msg.sender].push(prescription);

        emit PrescriptionAdded(patientAddress, msg.sender, prescription);
    }

    function getPatient(address patientAddress) public view returns (
        string memory name,
        uint age,
        string memory bloodType,
        string memory medicalCondition,
        address createdBy
    ) {
        Patient memory patient = patients[patientAddress];

        return (
            patient.name,
            patient.age,
            patient.bloodType,
            patient.medicalCondition,
            patient.createdBy
        );
    }

    function getPrescriptions(address patientAddress, address doctorAddress) public view returns (string[] memory) {
        return patients[patientAddress].prescriptions[doctorAddress];
    }
}
