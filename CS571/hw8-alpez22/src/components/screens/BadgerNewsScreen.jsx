import { Text, ScrollView, TouchableOpacity } from "react-native";
import React, { useState, useEffect, useContext } from "react";
import BadgerNewsItemCard from "./BadgerNewsItemCard";
import { createStackNavigator } from "@react-navigation/stack";
import { useNavigation } from "@react-navigation/native";
import BadgerArticleDetails from "./BadgerArticleDetails";
import BadgerPreferencesScreen from "./BadgerPreferencesScreen";
import BadgerContext from "../BadgerContext";

const Stack = createStackNavigator();

function BadgerNewsScreen(props) {
    EXPO_PUBLIC_CS571_BADGER_ID = "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49";
    const [ prefs, setPrefs ] = useContext(BadgerContext);
    const [articles, setArticles] = useState([]);
    const navigation = useNavigation();
    const [filteredArticles, setFilteredArticles] = useState([]);

    useEffect(() => {
        fetch("https://cs571.org/api/f23/hw8/articles", {
            headers: {
                "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID
            }
        })
        .then(res => res.json())
        .then(data => {
            setArticles(data);
            const filtered = data.filter((article) => article.tags.some(tag => prefs[tag]));
            setFilteredArticles(filtered);
        })
        .catch((error) => console.error("Error thrown in fetch: ", error));
    }, [prefs]);

    const navigateToArticleDetails = (fullArticleId) => {
        navigation.navigate("ArticleDetails", {fullArticleId});
    }
    
    return (
        <Stack.Navigator>
            <Stack.Screen name="News">
                {() => (
                    <ScrollView>
                        {filteredArticles && filteredArticles.length > 0 ? (
                                filteredArticles.map(article => (
                                    <TouchableOpacity key={article.id} onPress={() => navigateToArticleDetails(article.fullArticleId)}>
                                        <BadgerNewsItemCard key={article.id} article={article} />
                                    </TouchableOpacity>
                                ))
                            ) : (
                                <Text style={{ fontSize: 20, alignSelf: "center" }}>No articles available. You must change Preferences.</Text>
                            )}
                    </ScrollView>
                )}
            </Stack.Screen>
            <Stack.Screen name="Preferences">
                {() => <BadgerPreferencesScreen/>}
            </Stack.Screen>
            <Stack.Screen name="ArticleDetails" component={BadgerArticleDetails} />
        </Stack.Navigator>
    )
}

export default BadgerNewsScreen;