import { StyleSheet, Text, View, TextInput, TouchableOpacity } from "react-native";
import React, { useState } from 'react';

function BadgerLoginScreen(props) {

    EXPO_PUBLIC_CS571_BADGER_ID = "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49";
    const [user, setUser] = useState('');
    const [pswd, setPswd] = useState('');

    return (<View style={styles.container}>
        <Text style={{ fontSize: 36 }}>BadgerChat Login</Text>
        <Text style={{ fontSize: 20, paddingTop: 20 }}>Username</Text>
        <TextInput
            style={styles.input}
            onChangeText={setUser}
            value={user}
        />
        <Text style={{ fontSize: 20, paddingTop: 20 }}>Password</Text>
        <TextInput
            style={styles.input}
            onChangeText={setPswd}
            value={pswd}
            secureTextEntry
        />
        <TouchableOpacity style={styles.buttonLogin} onPress={() => props.handleLogin(user, pswd)}>
            <Text style={{ color: "white", fontSize: 15 }}>LOGIN</Text>
        </TouchableOpacity>
        <Text style={{ fontSize: 20, padding: 20 }}>New here?</Text>
        <View>
            <TouchableOpacity style={styles.buttonSignin} onPress={() => props.setIsRegistering(true)}>
                <Text style={{ color: "white", fontSize: 15 }}>SIGNUP</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.buttonSignin} onPress={() => props.setIsGuest(true)}>
                <Text style={{ color: "white", fontSize: 15 }}>Continue as Guest</Text>
            </TouchableOpacity>
        </View>
    </View>)
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
        alignItems: 'center',
        justifyContent: 'center',
    },
    input: {
        height: 40,
        margin: 12,
        borderWidth: 1,
        padding: 10,
        width: "80%",
    },
    buttonLogin: {
        backgroundColor: "crimson",
        padding: 10,
        margin: 10,
        alignItems: "center",
        borderRadius: 5
    },
    buttonSignin: {
        backgroundColor: "grey",
        padding: 10,
        margin: 10,
        alignItems: "center",
        borderRadius: 5
    }
});

export default BadgerLoginScreen;