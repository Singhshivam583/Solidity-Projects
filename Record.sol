// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract StudentRecord{
    struct Student{
        uint rollNo;
        string Name;
        uint[3] Marks;
    }
    address ClassTeacher;
    mapping(uint=>Student) AllRecords;

    constructor(){
        ClassTeacher=msg.sender;
    }

    modifier ClassTeacherAllowed(){
        require(ClassTeacher==msg.sender,"Only Class Teachers Are Allowed");
        _;
    }
    // get hint of constructor and modifier from your solution 

    function addRecords(uint index,uint _rollNo,string memory _name,uint eng,uint maths,uint hindi)public  ClassTeacherAllowed() {
        require(index==_rollNo || (index!=0 && _rollNo!=0),"Enter Idex value Same as RollNo.");
        // AllRecords[index].rollNo=_rollNo;
        // AllRecords[index].Name=_name;
        // AllRecords[index].Marks=[hindi,eng,maths];
        AllRecords[index]=Student(_rollNo,_name,[hindi,eng,maths]);
    }

    function getRecords(uint rollNo) public  ClassTeacherAllowed() view returns(Student memory){
        return AllRecords[rollNo];
    }

    function delRecords(uint rollNo) public  ClassTeacherAllowed(){
        require(rollNo>0,"Enter Valid RollNo.");
        delete AllRecords[rollNo];
    }

}