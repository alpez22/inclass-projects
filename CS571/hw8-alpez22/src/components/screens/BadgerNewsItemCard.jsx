import React from "react";
import { View, Image, Text } from "react-native";
import { Card } from "react-native-elements";

const BadgerNewsItemCard = ({ article }) => {
  return (
    <Card containerStyle={{ borderRadius: 20 }}>
        <Image style={{ width: 200, height: 100, alignSelf:"center" }} source={{ uri: `https://raw.githubusercontent.com/CS571-F23/hw8-api-static-content/main/articles/${article.img}` }}/>
        <View style={{ padding: 10, alignSelf:"center" }}>
            <Text style={{ fontWeight: "bold" }}>{article.title}</Text>
        </View>
    </Card>
  );
};

export default BadgerNewsItemCard;