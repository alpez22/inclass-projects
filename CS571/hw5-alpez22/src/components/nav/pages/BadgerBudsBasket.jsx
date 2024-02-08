import React from "react";
import { useContext } from "react";
import { useState, useEffect } from "react";
import { Container, Row, Col } from "react-bootstrap";
import BadgerBudBasketSummary from "./BadgerBudBasketSummary";
import BadgerBudsDataContext from "../../../contexts/BadgerBudsDataContext";
export default function BadgerBudsBasket(props) {

    const data = useContext(BadgerBudsDataContext);
    const savedCatIds = sessionStorage.getItem("savedCatIds") 
            ? JSON.parse(sessionStorage.getItem("savedCatIds")) 
            : ["0"];
    const updatedCats = data.filter(cat => savedCatIds.includes(cat.id));
    const [cats, setCats] = useState(updatedCats);
    
    const filterUnSelect = () => {
        const updateCats = data.filter(cat => savedCatIds.includes(cat.id));
        setCats(updateCats);
    }

    useEffect(() => {
        filterUnSelect();
    }, [])

    console.log(savedCatIds.length);

    return <div>
        <h1>Badger Buds Basket</h1>
        <p>These cute cats could be all yours!</p>
        {savedCatIds[0] == "0" || savedCatIds.length == 0
        ? <p>You have no buds in your basket!</p>
        : <p></p>}

        <Container fluid>
            <Row>
                {cats.map((cat) => (
                    <Col key={cat.id} xs={12} md={6} lg={4} xl={3}>
                        <BadgerBudBasketSummary 
                            key={cat.id} 
                            id={cat.id}
                            imgIds={cat.imgIds}
                            name={cat.name}
                            unSelectFilter={() => filterUnSelect()}
                            />
                    </Col>
                ))}
            </Row>
        </Container>
    </div>
}