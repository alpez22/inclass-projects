import { Alert, Button, StyleSheet, Text, View, TextInput, TouchableOpacity, ScrollView, SafeAreaView, Modal } from "react-native";
import React, { useState, useEffect } from 'react';
import BadgerChatMessage from "../helper/BadgerChatMessage";
import * as SecureStore from 'expo-secure-store';

function BadgerChatroomScreen(props) {
    EXPO_PUBLIC_CS571_BADGER_ID = "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49";
    const [chatroomInfo, setChatroomInfo] = useState({ messages: [] });
    const [currPage, setCurrPage] = useState(1);
    const totalPages = 4;
    const [modalVisible, setModalVisible] = useState(false);
    const [postTitle, setPostTitle] = useState('');
    const [postBody, setPostBody] = useState('');
    const [reload, setReload] = useState(false);
    const [userName, setUsername] = useState('');
    
    useEffect(() => {
        // hmm... maybe I should load the chatroom names here
        fetch(`https://cs571.org/api/f23/hw9/messages?chatroom=${props.chatroom}&page=${currPage}`, {
            headers: {
              "Content-Type": "application/json",
              "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID
            }
          })
          .then(response => response.json())
          .then(data => {
            setChatroomInfo({ messages: data.messages })
            setReload(false);
          });

          SecureStore.getItemAsync('userName').then(fetchedUser => {
            if (fetchedUser) {
                setUsername(fetchedUser);
            } else {
                console.log("Username not found in SecureStore");
            }
        }).catch(error => {
            console.error("Error fetching username from SecureStore:", error);
        });
    }, [props.chatroom, currPage, reload]);

    const handlePrevPage = () => {
        if (currPage > 1) {
            setCurrPage(currPage - 1);
        }
    };

    const handleNextPage = () => {
        if (currPage < totalPages) {
            setCurrPage(currPage + 1);
        }
    };

    function handleCreatePost() {
        // Ensure both title and body are present
        if (!postTitle.trim() || !postBody.trim()) {
            Alert.alert("Both title and body are required.");
            return;
        }
        SecureStore.getItemAsync('userToken').then(token => {
            if(token) {
                fetch(`https://cs571.org/api/f23/hw9/messages?chatroom=${props.chatroom}`, {
                method: 'POST',
                headers: {
                    "Content-Type": "application/json",
                    "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID,
                    "Authorization": `Bearer ${token}`
                },
                body: JSON.stringify({ 
                    title: postTitle, 
                    content: postBody })
                })
                .then(res => {
                if (res.status != 200) {
                    throw new Error()
                }
                    return res.json()
                })
                .then((data) => {
                    setCurrPage(1);
                    setModalVisible(false);
                    Alert.alert("Successfully Posted!");
                    setReload(true);
                })
                .catch((error) => Alert.alert(error.message))
            }
            else{
                Alert.alert("Authorization token not found.");
            }
        })
        .catch(error => {
            Alert.alert("Failed to retrieve token: ", error);
        });
    };

    function handleDeletion(messageId) {
        SecureStore.getItemAsync('userToken').then(token => {
            if(token) {
                fetch(`https://cs571.org/api/f23/hw9/messages?id=${messageId}`, {
                    method: 'DELETE',
                    headers: {
                        "Content-Type": "application/json",
                        "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID,
                        "Authorization": `Bearer ${token}`
                    }
                })
                .then(res => {
                if (res.status != 200) {
                    throw new Error()
                }
                    return res.json()
                })
                .then((data) => {
                    setCurrPage(1);
                    Alert.alert("Successfully Deleted!");
                    setReload(true);
                })
                .catch((error) => Alert.alert(error.message))
            }
            else{
                Alert.alert("Authorization token not found.");
            }
        })
        .catch(error => {
            Alert.alert("Failed to retrieve token: ", error);
        });
    }

    return (
    <SafeAreaView style={styles.container}>
        <ScrollView>
            {chatroomInfo.messages && chatroomInfo.messages.length > 0 ?
                chatroomInfo.messages.map((message, index) => (
                    <BadgerChatMessage
                        key={index}
                        title={message.title}
                        poster={message.poster}
                        content={message.content}
                        chatroom={message.chatroom}
                        created={message.created}
                        showDeleteButton = {userName === message.poster}
                        onDelete={() => handleDeletion(message.id)}
                    />))
            : <Text>There's nothing here!</Text>}
        </ScrollView>
        <View style={styles.textPagCont}>
            <Text style={{fontSize: 18}}>Page {currPage} of {totalPages}</Text>
        </View>
        <View style={styles.paginationContainer}>
            <TouchableOpacity onPress={handlePrevPage} disabled={currPage === 1} style={currPage === 1 ? styles.disabledButton : styles.button}>
                <Text style={currPage === 1 ? { color: "white", fontSize: 18 } : { color: "white", fontSize: 18 }}>Previous</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={handleNextPage} disabled={currPage === totalPages} style={currPage === totalPages ? styles.disabledButton : styles.button}>
                <Text style={currPage === totalPages ? { color: "white", fontSize: 18 } : { color: "white", fontSize: 18 }}>Next</Text>
            </TouchableOpacity>
        </View>
        <View>
            <TouchableOpacity style={userName.trim().length == 0 ? styles.addPageDisabled : styles.addPage} onPress={() => setModalVisible(true)} disabled={userName.trim().length == 0}>
                <Text style={{ color: "white", fontSize: 18 }}>ADD POST</Text>
            </TouchableOpacity>

            <Modal
                animationType="slide"
                transparent={true}
                visible={modalVisible}
                onRequestClose={() => setModalVisible(!modalVisible)}
            >
                <View style={styles.modalView}>
                    <Text style={{fontSize: 18 }}>Create a Post!</Text>

                    <Text style={{fontSize: 18, paddingTop: 10 }}>Title</Text>
                    <TextInput
                        style={styles.input}
                        value={postTitle}
                        onChangeText={setPostTitle}
                    />
                    <Text style={{fontSize: 18 }}>Content</Text>
                    <TextInput
                        style={styles.input}
                        value={postBody}
                        onChangeText={setPostBody}
                        multiline
                    />
                    <Button 
                        title="Create Post" 
                        onPress={handleCreatePost} 
                        disabled={!postTitle.trim() || !postBody.trim()} 
                    />
                    <Button title="Cancel" onPress={() => setModalVisible(false)} />
                </View>
            </Modal>
        </View>
    </SafeAreaView>
    )
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center'
    },
    textPagCont: {
        flexDirection: 'row',
        justifyContent: 'space-around',
        alignSelf: "center",
        alignContent: "center",
        alignItems: 'center',
        padding: 10,
        width: '80%',
    },
    paginationContainer: {
        flexDirection: 'row',
        justifyContent: 'space-around',
        alignSelf: "center",
        alignContent: "center",
        alignItems: 'center',
        width: '80%',
    },
    button: {
        backgroundColor: "blue",
        padding: 10,
        margin: 10,
        alignItems: "center",
        borderRadius: 5,
        width: "50%",
        paddingHorizontal: 10
    },
    disabledButton: {
        backgroundColor: "#c2c0c0",
        padding: 10,
        margin: 10,
        alignItems: "center",
        borderRadius: 5,
        width: "50%",
        paddingHorizontal: 10
    },
    addPage: {
        backgroundColor: "#f71616",
        padding: 10,
        alignItems: "center",
        borderRadius: 5,
        width: "100%"
    },
    addPageDisabled: {
        backgroundColor: "#c2c0c0",
        padding: 10,
        alignItems: "center",
        borderRadius: 5,
        width: "100%"
    },
    modalView: {
        margin: 20,
        marginTop: 200,
        backgroundColor: "white",
        borderRadius: 20,
        padding: 35,
        alignItems: "center",
        shadowColor: "#000",
        shadowOffset: {
            width: 0,
            height: 2
        },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
        elevation: 5,
        justifyContent: 'center'
    },
    input: {
        width: '80%',
        padding: 10,
        marginVertical: 10,
        borderWidth: 1,
        borderColor: 'gray',
        borderRadius: 5
    },
});

export default BadgerChatroomScreen;