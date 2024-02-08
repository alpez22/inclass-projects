import { useState } from "react";

export default function BakedGood(props) {

    const [quant, setQuant] = useState(0);

    function increase(){
        setQuant(quant + 1);
    }

    function decrease(){
        setQuant(quant - 1);
    }

    const decreaseButton = {
        backgroundColor: 'rgba(255, 0, 0, 0.3)'
    }

    const increaseButton = {
        backgroundColor: 'rgba(0, 255, 0, 0.3)'
    }

    const isFeaturedGood = {
        backgroundColor: props.featured ? '#102a52' : '#dce8fa',
        fontWeight: props.featured ? 'bold' : 'normal',
        color: props.featured ? '#dce8fa' : '#102a52',
    }

    return <div style={isFeaturedGood}>
        <h2>{props.name}</h2>
        <p>{props.description}</p>
        <p>${props.price}</p>
        <div>
            <button className="inline" onClick={decrease} disabled={quant <= 0} style={decreaseButton}>-</button>
            <p className="inline">{quant}</p>
            <button className="inline" onClick={increase} style={increaseButton}>+</button>
        </div>
    </div>
}