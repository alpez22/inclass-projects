import { useContext } from "react";
import { Text, View, Switch } from "react-native";
import BadgerContext from "../BadgerContext";

function BadgerPreferencesScreen(props) {

    const [ prefs, setPrefs ] = useContext(BadgerContext);

    const switchesPrefs = (tags) => {
        setPrefs((prevPrefs) => ({
            ...prevPrefs,
            [tags]: !prevPrefs[tags],
          }));
    }

    return (
    <View>
        {Object.keys(prefs) && Object.keys(prefs).length > 0 ? (
            Object.keys(prefs).map((tag) => (
                <View key={tag} style={{ alignSelf:"center", padding:30 }}>
                <Text style={{fontSize: 30}}>{tag}</Text>
                    <Switch style={{ alignSelf: "center" }} value={prefs[tag]} onValueChange={() => switchesPrefs(tag)}/>
                </View>
            )) 
            ) : (
                <Text>No preferences available...</Text>
            )}
    </View>)
}

export default BadgerPreferencesScreen;