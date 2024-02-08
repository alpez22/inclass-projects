import { Text, View, ScrollView, Image, Animated, Pressable, Linking } from "react-native";
import React, { useState, useEffect } from "react";

function BadgerArticleDetails({ route }) {
    const { fullArticleId } = route.params;
    const [articleDetails, setArticleDetails] = useState({});
    const [loading, setLoading] = useState(true);
    const fadeIn = new Animated.Value(0);

    useEffect(() => {
        fetch(`https://cs571.org/api/f23/hw8/article?id=${fullArticleId}`, {
            headers: {
                "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID
            }
        })
        .then((res) => res.json())
        .then((data) => {
            setArticleDetails(data);
            setLoading(false);
        })
        .catch((error) => console.error("Error thrown in fetch: ", error));
    }, [fullArticleId]);

    useEffect(() =>{
        if(!loading){
            Animated.timing(fadeIn, {
                toValue: 1,
                duration: 2000,
                useNativeDriver: true,
            }).start()
        }
    }, [loading])

    return (
        <View>
        {loading ? (
            <Text style={{ fontSize: 30 }}>The content is loading!</Text>
        ) : (
            <Animated.View style={{ opacity:fadeIn }}>
                <ScrollView>
                    <Image style={{ width: 400, height: 200, alignSelf:"center" }} source={{ uri: `https://raw.githubusercontent.com/CS571-F23/hw8-api-static-content/main/articles/${articleDetails.img}` }}/>
                    <Text style={{ fontWeight: "bold", fontSize: 20 }}>{articleDetails.title}</Text>
                    <Text style={{ fontSize: 17 }}>By {articleDetails.author} on {articleDetails.posted}</Text>
                    <Text></Text>
                    <Pressable onPress={() => Linking.openURL(articleDetails.url)}>
                        <Text style={{ color: 'blue', textDecorationLine: 'underline', fontSize: 20}}>
                        Read full article here.
                        </Text>
                    </Pressable>
                    <Text></Text>
                    {articleDetails.body.map((paragraph, index) => (
                        <Text key={index} style={{ fontSize: 16 }}>{paragraph}</Text>
                    ))}
                </ScrollView>
            </Animated.View>
        )}
    </View>)
}

export default BadgerArticleDetails;