import { Col, Button, Container, Form, Row } from "react-bootstrap";
import { useState, useEffect } from "react";
import Student from "./Student";

const Classroom = () => {
  const [studentData, setStudentData] = useState([]);
  const [searchStudent, setSearchStudent] = useState({
    name: "",
    major: "",
    interest: "",
  });
  const [currentPage, setCurrentPage] = useState(1);

  useEffect(() => {
    fetch("https://cs571.org/api/f23/hw4/students", {
      headers: {
        "X-CS571-ID": CS571.getBadgerId(),
      },
    })
      .then((res) => res.json())
      .then((data) => {
        console.log(data);
        setStudentData(data);
      });
  }, []);

  const handleSearchChange = (e) => {
    const { id, value } = e.target;
    setSearchStudent((prevSearch) => ({ ...prevSearch, [id]: value.trim() }));
    setCurrentPage(1);
  };

  const filteredStudents = studentData.filter((student) => {
    const nameMatching =
      student.name.first.toLowerCase().includes(searchStudent.name.toLowerCase()) ||
      student.name.last.toLowerCase().includes(searchStudent.name.toLowerCase());

    const majorMatching = student.major.toLowerCase().includes(searchStudent.major.toLowerCase());

    const interestsMatching = student.interests.some((interest) =>
      interest.toLowerCase().includes(searchStudent.interest.toLowerCase())
    );

    return nameMatching && majorMatching && interestsMatching;
  });

  const handleSearchReset = () => {
    setSearchStudent({ 
        name: "", 
        major: "", 
        interest: "" 
    });
    setCurrentPage(1);
  };

  const pageNumbers = Array.from({ length: Math.ceil(studentData.length / 24) }, (_, index) => index + 1);
  const currentStudents = filteredStudents.slice((currentPage * 24) - 24, currentPage * 24);
  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  return (
    <div>
      <h1>Badger Book - Fall 2023</h1>
      <p>Search for students below!</p>
      <hr />
      <Form>
        <Form.Label htmlFor="searchName">Name</Form.Label>
        <Form.Control id="name" onChange={handleSearchChange} value={searchStudent.name} />
        <Form.Label htmlFor="searchMajor">Major</Form.Label>
        <Form.Control id="major" onChange={handleSearchChange} value={searchStudent.major} />
        <Form.Label htmlFor="searchInterest">Interest</Form.Label>
        <Form.Control id="interest" onChange={handleSearchChange} value={searchStudent.interest} />
        <br />
        <Button variant="neutral" onClick={handleSearchReset}>Reset Search</Button>
        <p>There are {filteredStudents.length} student(s) matching your search.</p>
      </Form>
      <Container fluid>
        <Row>
          {currentStudents.map((student) => (
            <Col key={student.id} xs={12} md={6} lg={4} xl={3}>
              <Student data={student} />
            </Col>
          ))}
        </Row>
      </Container>
      <ul className="pagination">
        <li className={(currentPage === 1) ? "page-item disabled" : "page-item"}>
          <a onClick={() => !(currentPage === 1) && paginate(currentPage - 1)} className="page-link">Previous</a>
        </li>
        {pageNumbers.map((number) => (
          <li key={number} className={number === currentPage ? "page-item active" : "page-item"}>
            <a onClick={() => paginate(number)} className="page-link">{number}</a>
          </li>
        ))}
        <li className={(currentPage === pageNumbers.length) || !(filteredStudents.length > 0) ? "page-item disabled" : "page-item"}>
          <a onClick={() => (!(currentPage === pageNumbers.length) && (filteredStudents.length > 0)) && paginate(currentPage + 1)} className="page-link">Next</a>
        </li>
      </ul>
    </div>
  );
};

export default Classroom;