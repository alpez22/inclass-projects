import BadgerLoginStatusContext from "../contexts/BadgerLoginStatusContext";
import React, { useEffect, useContext } from 'react';
import { useNavigate } from 'react-router-dom';

export default function BadgerLogout() {

    const [, setLoginStatus] = useContext(BadgerLoginStatusContext);
    const navigate = useNavigate();

    useEffect(() => {
        fetch('https://cs571.org/api/f23/hw6/logout', {
            method: 'POST',
            headers: {
                "X-CS571-ID": CS571.getBadgerId()
            },
            credentials: "include"
        }).then(res => res.json()).then(json => {
            //remove logged in user and return to home and alert
            setLoginStatus(null);
            sessionStorage.setItem('loggedin_username', null);
            navigate(`/`);
            alert('Successfully Logged Out!');
        })
    }, []);

    return <>
        <h1>Logout</h1>
        <p>You have been successfully logged out.</p>
    </>
}
