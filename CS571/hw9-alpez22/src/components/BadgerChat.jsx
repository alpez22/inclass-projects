import { useEffect, useState } from 'react';
import { Alert } from "react-native";
import { createDrawerNavigator } from '@react-navigation/drawer';
import { NavigationContainer } from '@react-navigation/native';

import * as SecureStore from 'expo-secure-store';
import BadgerChatroomScreen from './screens/BadgerChatroomScreen';
import BadgerRegisterScreen from './screens/BadgerRegisterScreen';
import BadgerLoginScreen from './screens/BadgerLoginScreen';
import BadgerLandingScreen from './screens/BadgerLandingScreen';
import BadgerLogoutScreen from './screens/BadgerLogoutScreen';
import BadgerConversionScreen from './screens/BadgerConversionScreen';


const ChatDrawer = createDrawerNavigator();

export default function App() {

  EXPO_PUBLIC_CS571_BADGER_ID = "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49";
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [isGuest, setIsGuest] = useState(false);
  const [isRegistering, setIsRegistering] = useState(false);
  const [chatrooms, setChatrooms] = useState([]);

  useEffect(() => {
    // hmm... maybe I should load the chatroom names here
    fetch('https://cs571.org/api/f23/hw9/chatrooms', {
        headers: {
          "Content-Type": "application/json",
          "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID
        }
      })
      .then(response => response.json())
      .then(data => {
        setChatrooms(data)
      });
  }, []);

  const handleLogOut = async () => {
    SecureStore.deleteItemAsync('userName');
    SecureStore.deleteItemAsync('userToken')
      .then(() => {
        setIsLoggedIn(false);
        Alert.alert("Logged out successfully.");
      })
      .catch(error => {
        Alert.alert("An error occurred while logging out.");
      });
  };

  const handleReSignUp = async () => {
    setIsRegistering(true);
    setIsGuest(false);
  };

  async function handleLogin(username, password) {
    try {
        const response = await fetch('https://cs571.org/api/f23/hw9/login', {
            method: 'POST',
            headers: {
              "Content-Type": "application/json",
              "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID
            },
            body: JSON.stringify({ username, password })
        });

        if (response.status === 401) {
            Alert.alert("Incorrect Password");
            return; // Stop the function execution if the password is incorrect
        } else if (response.status !== 200) {
            console.log(response.status);
            throw new Error("Login failed with status: " + response.status);
        }

        const data = await response.json();
        await SecureStore.setItemAsync('userToken', data.token);
        await SecureStore.setItemAsync('userName', data.user.username);

        setIsLoggedIn(true);
        setIsGuest(false);
    } catch (error) {
      console.log(error)
    }
}


  // async function handleLogin(username, password) {
  //   // hmm... maybe this is helpful!
  //   fetch('https://cs571.org/api/f23/hw9/login', {
  //       method: 'POST',
  //       headers: {
  //         "Content-Type": "application/json",
  //         "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID
  //       },
  //       body: JSON.stringify({ 
  //         username: username, 
  //         password: password })
  //     })
  //     .then(res => {
  //       if (res.status == 401) {
  //         Alert.alert("Incorrect Password");
  //         throw new Error()
  //       }else if(res.status == 200){
  //         return res.json
  //       }else{
  //         console.log(res.status)
  //         throw new Error();
  //       }
  //     })
  //     .then((data) => {
  //       setIsLoggedIn(true)
  //       setIsGuest(false);
  //       SecureStore.setItemAsync('userToken', data.token);
  //       SecureStore.setItemAsync('userName', data.user.username);
  //       console.log(SecureStore.getItemAsync('userName', data.user.username));
  //     })
  //     .catch(error => console.log(error))
  // }

  function handleSignup(username, password) {
    // hmm... maybe this is helpful!
    fetch('https://cs571.org/api/f23/hw9/register', {
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID
        },
        body: JSON.stringify({ username, password })
      })
      .then(res => {
        if(res.status == 409){
          Alert.alert("Username already taken");
          throw new Error();
        }else if(res.status == 200){
          return res.json
        }else{
          throw new Error();
        }
      })
      .then(() => {
          setIsRegistering(false); //not registering anymore
          setIsLoggedIn(true);
          handleLogin(username, password); // log in after registered
      })
  }

  if (isLoggedIn || isGuest) {
    return (
      <NavigationContainer>
        <ChatDrawer.Navigator>
          <ChatDrawer.Screen name="Landing" component={BadgerLandingScreen} />
          {
            chatrooms.map(chatroom => {
              return <ChatDrawer.Screen key={chatroom} name={chatroom}>
                {(props) => <BadgerChatroomScreen {...props} chatroom={chatroom} />}
              </ChatDrawer.Screen>
            })
          }
          {
            !isLoggedIn && isGuest 
            ? <ChatDrawer.Screen name="SignUp" options={{drawerItemStyle: { backgroundColor: 'pink', opacity: "10%" }, drawerLabelStyle: { color: 'gray' }}}>
                {(props) => <BadgerConversionScreen {...props} onReSignUp={handleReSignUp} />}
              </ChatDrawer.Screen>
            : <ChatDrawer.Screen name="LogOut" options={{drawerItemStyle: { backgroundColor: 'pink', opacity: "10%" }, drawerLabelStyle: { color: 'gray' }}}>
                {(props) => <BadgerLogoutScreen {...props} onLogOut={handleLogOut} />}
              </ChatDrawer.Screen>
          }
         
        </ChatDrawer.Navigator>
      </NavigationContainer>
    );
  } else if (isRegistering) {
    return <BadgerRegisterScreen handleSignup={handleSignup} setIsRegistering={setIsRegistering} />
  } else {
    return <BadgerLoginScreen handleLogin={handleLogin} setIsRegistering={setIsRegistering} setIsGuest={setIsGuest}/>
  }
}