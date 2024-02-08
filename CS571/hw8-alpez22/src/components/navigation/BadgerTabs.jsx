import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import BadgerNewsScreen from "../screens/BadgerNewsScreen";
import BadgerPreferencesScreen from "../screens/BadgerPreferencesScreen";

const Tab = createBottomTabNavigator();

function BadgerTabs(props) {
    return <Tab.Navigator
        screenOptions={({route}) => ({
            headerShown:route.name === `News` ? false : true,
        })}>
    <Tab.Screen name="News" component={BadgerNewsScreen}></Tab.Screen>
    <Tab.Screen name="Preferences" component={BadgerPreferencesScreen}></Tab.Screen>
  </Tab.Navigator>
}

export default BadgerTabs;