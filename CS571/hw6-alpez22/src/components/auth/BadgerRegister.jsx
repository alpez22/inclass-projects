import React from 'react';
import { Button, Form } from "react-bootstrap";
import { useEffect, useState } from "react";
import { useNavigate } from 'react-router-dom';

import BadgerLayout from "../structural/BadgerLayout";

export default function BadgerRegister() {

    const[username, setUsername] = useState("");
    const[password, setPassword] = useState("");
    const[resetPwd, setResetPwd] = useState("");
    const navigate = useNavigate();

    // Create the register component.
    const register = () => {

        if (!username || !password) {
            alert('You must provide both a username and password!');
            return;
        }
        if (password !== resetPwd) {
            alert('Your passwords do not match!');
            return;
        }

        fetch('https://cs571.org/api/f23/hw6/register', {
            method: 'POST',
            headers: {
                "Content-Type": "application/json",
                "X-CS571-ID": CS571.getBadgerId()
            },
            body: JSON.stringify({
                username: username,
                password: password
            })
        }).then(res => {
                if (res.status === 200) {
                    return res.json();
                } else if(res.status === 409){
                    throw new Error(`Username already taken`);
                }else {
                    throw new Error();
                }
            }).then(json => {
                console.log("Recieved back...");
                console.log(json);
                navigate(`/`);
                alert('Successfully Registered!');
            }).catch(e => {
                if (e.message === `Username already taken`) {
                    alert('That username has already been taken!');
                }else{
                    alert('An error occured while making the request')
                }
            })
    }

    return <>
        <h1>Register</h1>

        <Form.Label id="title" htmlFor="username">Username</Form.Label>
        <Form.Control type="text" value={username} onChange={(e) => setUsername(e.target.value)} id="username"></Form.Control>
        <Form.Label id="title" htmlFor="password">Password</Form.Label>
        <Form.Control  type="password" value={password} onChange={(e) => setPassword(e.target.value)} id="password"></Form.Control>
        <Form.Label id="title" htmlFor="repeat-password">Repeat Password</Form.Label>
        <Form.Control  type="password" value={resetPwd} onChange={(e) => setResetPwd(e.target.value)} id="repeat-password"></Form.Control>
        <br></br>
        <Button onClick={register}>Register</Button>
    </>
}
