import { Button, Image, Text, View } from "react-native";

export default function BadgerBakedGood({ id, name, imgSrc, price, upperLimit, doAdd, doRemove, quantity, doOrder }) {
    const priceFormatted = parseFloat(price).toFixed(2);
    return <View>
        <Image style={{ width: 100, height: 100, alignSelf:"center" }} source={{ uri: imgSrc }}/>
        <Text style={{ fontSize: 30, textAlign: "center" }}>{name}</Text>
        <Text style={{ fontSize: 15, textAlign: "center" }}>${priceFormatted}</Text>
        <Text style={{ fontSize: 15, textAlign: "center" }}>{upperLimit === -1 
            ? `You can order an unlimited amount of units!` 
            : `You can order up to ${upperLimit} units!`}
        </Text>

        <View style={{ flexDirection: "row", justifyContent: "center", margin: 10 }}>
            <Button title="-" onPress={() => doRemove(id)} disabled={quantity <= 0} />
            <Text style={{ marginTop: 10 , marginHorizontal: 10}}>{quantity}</Text>
            <Button title="+" onPress={() => doAdd(id, upperLimit)} disabled={upperLimit !== -1 && quantity >= upperLimit} />
        </View>
    </View>
}
