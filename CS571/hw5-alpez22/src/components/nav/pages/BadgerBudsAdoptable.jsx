import React from "react";
import { useContext } from "react";
import { useState, useEffect } from "react";
import { Container, Row, Col } from "react-bootstrap";
import BadgerBudSummary from "./BadgerBudSummary";
import BadgerBudsDataContext from "../../../contexts/BadgerBudsDataContext";

export default function BadgerBudsAdoptable(props) {

    const data = useContext(BadgerBudsDataContext);
    const [cats, setCats] = useState(data);

    const adoptedCatIds = sessionStorage.getItem("adoptedCatIds") 
            ? sessionStorage.getItem("adoptedCatIds") 
            : ["0"];

    const savedCatIds = sessionStorage.getItem("savedCatIds") 
            ? sessionStorage.getItem("savedCatIds") 
            : ["0"];

    
    const filterSave = () => {
        const updateCats = data.filter(cat => !savedCatIds.includes(cat.id) && !adoptedCatIds.includes(cat.id));
        setCats(updateCats);
    }

    useEffect(() => {
        filterSave();
    }, [])

    return (<div>
        <h1>Available Badger Buds</h1>
        <p>The following cats are looking for a loving home! Could you help?</p>
        {savedCatIds == null
        ? <p>No buds are available for adoption!</p>
        : <p></p>}

        <Container fluid>
            <Row>
                {cats.map((cat) => (
                    <Col key={cat.id} xs={12} md={6} lg={4} xl={3}>
                        <BadgerBudSummary 
                            key={cat.id} 
                            id={cat.id}
                            imgIds={cat.imgIds}
                            name={cat.name} 
                            gender={cat.gender}
                            breed={cat.breed}
                            age={cat.age}
                            description={cat.description}
                            saveFilter={() => filterSave()}
                            />
                    </Col>
                ))}
            </Row>
        </Container>
    </div>);
}