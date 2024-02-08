import { Alert, Button, Text, View } from "react-native";
import { useEffect, useState } from "react";
import CS571 from "@cs571/mobile-client"
import BadgerBakedGood from "./BadgerBakedGood";

export default function BadgerBakery() {
    EXPO_PUBLIC_CS571_BADGER_ID = "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49";
    const [goods, setGoods] = useState({}); //obj
    const [keys, setKeys] = useState([]); //arr
    const [currIndex, setCurrIndex] = useState(0);
    const [basket, setBasket] = useState({}); //obj

    useEffect(() => {
        fetch("https://cs571.org/api/f23/hw7/goods", {
            headers: {
                "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID
            }
        })
        .then(res => res.json())
        .then(data => {
            setGoods(data);
            setKeys(Object.keys(data));
        })
    }, []);

    const doPrevious = () => {
        if (currIndex > 0) {
          setCurrIndex(currIndex - 1);
        }
    };
    
    const doNext = () => {
        if (currIndex < keys.length - 1) {
            setCurrIndex(currIndex + 1);
        }
    };

    const addToBasket = (id, upperLimit) => {
        setBasket((prevBasket) => {
            const prevQuantity = id in prevBasket ? prevBasket[id] : 0;
            return { ...prevBasket, [id]: upperLimit == -1 
                                                    ? prevQuantity + 1 
                                                    : Math.min(prevQuantity + 1, upperLimit)};
        });
      };
    
    const removeFromBasket = (id) => {
        setBasket((prevBasket) => {
            return { ...prevBasket, [id]: prevBasket[id].quantity == 0 
                                                    ? 0 
                                                    : prevBasket[id] - 1};
        });
      };

    const calculateOrder = () => {
        let total = 0;
        for(id in basket){
            total += goods[id].price * basket[id];
        }
        return total;
    }

    function doOrder(){
        let numItems = 0;
        for(id in basket){
            numItems += basket[id];
        }
        Alert.alert(`Order Confirmed! Your order contains ${numItems} items and costs $${calculateOrder().toFixed(2)}!`);
        setBasket({});
        setCurrIndex(0);
    }

    return <View>
        <Text>Welcome to Badger Bakery!</Text>
        <BadgerBakedGood
            id= {keys[currIndex]}
            {...goods[keys[currIndex]]}
            doAdd={addToBasket}
            doRemove={removeFromBasket}
            quantity={basket[keys[currIndex]] || 0}
        />
        <View>
            <Button title="Previous" onPress={doPrevious} disabled={currIndex === 0} />
            <Button title="Next" onPress={doNext} disabled={currIndex === keys.length - 1} />
        </View>
        <View style={{ justifyContent: "center", margin: 10 }}>
            <Text style={{ marginTop: 10 , marginHorizontal: 10}}>Order Total: ${calculateOrder().toFixed(2)}</Text>
            <Button title="Place Order" onPress={() => doOrder()} disabled={calculateOrder() == 0}/>
        </View>
    </View>
}
