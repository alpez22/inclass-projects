import { StyleSheet, Text, View, TextInput, TouchableOpacity } from "react-native";
import React, { useState, useEffect } from 'react';

function BadgerRegisterScreen(props) {

    EXPO_PUBLIC_CS571_BADGER_ID = "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49";
    const [user, setUser] = useState('');
    const [pswd, setPswd] = useState('');
    const [confirmPswd, setConfirmPswd] = useState('');
    const [isPswdEntered, setIsPswdEntered] = useState(false);

    useEffect(() => {
        if(pswd && pswd == confirmPswd){
            setIsPswdEntered(true);
        }else{
            setIsPswdEntered(false);
        }
      }, [pswd, confirmPswd]);

    return (<View style={styles.container}>
        <Text style={{ fontSize: 36 }}>Join BadgerChat!</Text>
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
        <Text style={{ fontSize: 20, paddingTop: 20 }}>Confirm Password</Text>
        <TextInput
            style={styles.input}
            onChangeText={setConfirmPswd}
            value={confirmPswd}
            secureTextEntry
        />
        {isPswdEntered ? <Text></Text> : <Text style={{ fontSize: 20, padding: 20, color: "red" }}>Please enter a password!</Text>}
        <View style={styles.buttonContainer}>
            <TouchableOpacity style={styles.buttonSignup} onPress={() => props.handleSignup(user, pswd)}>
                <Text style={{ color: "white", fontSize: 15 }}>SIGNUP</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.buttonNvm} onPress={() => props.setIsRegistering(false)}>
                <Text style={{ color: "white", fontSize: 15 }}>NEVERMIND</Text>
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
    buttonContainer: {
        flexDirection: 'row',
        alignItems: "center",
        width: '80%',
        justifyContent: 'center',
    },
    input: {
        height: 40,
        margin: 12,
        borderWidth: 1,
        padding: 10,
        width: '80%',
    },
    buttonSignup: {
        backgroundColor: "crimson",
        padding: 10,
        margin: 10,
        alignItems: "center",
        borderRadius: 5
    },
    buttonNvm: {
        backgroundColor: "grey",
        padding: 10,
        margin: 10,
        alignItems: "center",
        borderRadius: 5
    }
});

export default BadgerRegisterScreen;