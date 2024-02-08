import React from 'react';
import { Button, Form } from "react-bootstrap";
import { useState, useContext } from "react";
import { useNavigate } from 'react-router-dom';
import BadgerLoginStatusContext from "../contexts/BadgerLoginStatusContext";

export default function BadgerLogin() {

    const[username, setUsername] = useState("");
    const[password, setPassword] = useState("");
    const [, setLoginStatus] = useContext(BadgerLoginStatusContext);
    const navigate = useNavigate();

    // Create the login component.
    const login = () => {
        if (!username || !password) {
            alert('You must provide both a username and password!');
            return;
        }

        fetch('https://cs571.org/api/f23/hw6/login', {
            method: 'POST',
            headers: {
                "Content-Type": "application/json",
                "X-CS571-ID": CS571.getBadgerId()
            },
            body: JSON.stringify({
                username: username,
                password: password
            }),
            credentials: "include"
        }).then(res => {
                if (res.status === 200) {
                    return res.json();
                } else if((res.status === 401)){
                    throw new Error(`Incorrect username or password`);
                }else {
                    throw new Error();
                }
            }).then(json => {
                console.log("Recieved back...");
                console.log(json);
                //add logged in user and navigate home and alert
                setLoginStatus(json.user.username);
                sessionStorage.setItem('loggedin_username', json.user.username);
                navigate(`/`);
                alert('Successfully Logged In!');
            }).catch(e => {
                if (e.message === `Incorrect username or password`) {
                    alert('Incorrect username or password!');
                }else{
                    alert(`An error occured while making the request: ${e.message}`)
                }
            })
    }

    return <>
        <h1>Login</h1>

        <Form.Label id="title" htmlFor="username">Username</Form.Label>
        <Form.Control type="text" value={username} onChange={(e) => setUsername(e.target.value)} id="username"></Form.Control>
        <Form.Label id="title" htmlFor="password">Password</Form.Label>
        <Form.Control  type="password" value={password} onChange={(e) => setPassword(e.target.value)} id="password"></Form.Control>
        <br></br>
        <Button onClick={login}>Login</Button>
    </>
}
