import { useEffect, useState } from "react"
import BakedGood from "./BakedGood";
import { Col, Container, Row } from "react-bootstrap";

export default function BadgerBakery() {

    const [bakedGoods, setBakedGoods] = useState([]);
    const [featuredGood, setIsFeaturedGood] = useState(null);
    const [loading, setIsLoading] = useState(true);

    useEffect(() => {
        fetch("https://cs571.org/api/f23/hw3/all-baked-goods", {
            headers: {
                "X-CS571-ID": CS571.getBadgerId()
            }
        })
        .then(res => res.json())
        .then(data => {
            console.log(data);
            setBakedGoods(data);
            const isFeatured = data.filter(bakedGood => bakedGood.featured);
            setIsFeaturedGood(isFeatured);
            setIsLoading(false);
        })
    }, [])

    return (
        <div>
            <div style={{ border: 'solid', backgroundColor:'#d7dade' }}>
            <h1>Badger Bakery</h1>
            <p>Welcome to our small-town bakery located in Madison, WI!</p>
            {
                loading ? 
                (<p>Loading...</p>) : 
                featuredGood ? 
                    (<p>Today's featured item is {featuredGood[0].name} for ${featuredGood[0].price}!</p>) :
                    (<p>Featured Item is unavailable!</p>)
            }
            </div>
            <br></br>
            <Container>
                <Row>
                {
                    bakedGoods.map(bakedGood => {
                        return <Col key={bakedGood.name} xs={12} md={6} lg={4} xl={3}>
                            <div style={{ border: 'solid' }}>
                            <BakedGood
                                name={bakedGood.name}
                                description={bakedGood.description}
                                price={bakedGood.price}
                                featured={bakedGood.featured}
                            />
                            </div>
                        </Col>
                    })
                }
                </Row>
            </Container>
        </div>
    );
}