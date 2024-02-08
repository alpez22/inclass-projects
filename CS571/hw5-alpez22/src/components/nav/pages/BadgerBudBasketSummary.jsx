import React from "react";
import { useState } from "react";

const BadgerBudSummary = ({id, imgIds, name, unSelectFilter}) => {
    let image = `https://raw.githubusercontent.com/CS571-F23/hw5-api-static-content/main/cats/${imgIds[0]}`;

    const catObjStyle = {
        border: "1px solid",
        borderRadius: "10px",
        padding: "10px",
        margin: "10px",
        width: "300px"
      };

    const catImgStyle = { 
        width: "100%", 
        height: "350px" 
    };

    const nameStyle = {
        border: "1px solid",
        borderRadius: "10px",
        marginTop: "10px",
        textAlign: "center",
    };

    const unSelectButtonStyle = {
        backgroundColor: "grey",
        color: "white",
        marginLeft: "50px",
        borderRadius: "10px",
        padding: "7px",
    };

    const adoptButtonStyle = {
        backgroundColor: "#08c74b",
        color: "white",
        marginLeft: "1px",
        width: "29%", 
        borderRadius: "10px",
        padding: "7px",
    };

    const unSelectCat = () => {
        //if savedCatIds exists, set savedCatIds to the array version of the saved cats, else it doesn't exist
        const savedCatIds = sessionStorage.getItem("savedCatIds") 
            ? JSON.parse(sessionStorage.getItem("savedCatIds")) 
            : [];
        
        //update savedCatIds if this new cat is in the savedCatIds array
        if(savedCatIds.includes(id)){
            //new arr minus id
            const newArr = [...savedCatIds].filter(catId => catId !== id);
            sessionStorage.setItem("savedCatIds", JSON.stringify(newArr));

            unSelectFilter();
            alert(`${name} has been removed from your basket!`);
        }
    }

    const adoptCat = () => {
        const adoptedCatIds = sessionStorage.getItem("adoptedCatIds") 
            ? JSON.parse(sessionStorage.getItem("adoptedCatIds")) 
            : [];

        const savedCatIds = sessionStorage.getItem("savedCatIds") 
            ? JSON.parse(sessionStorage.getItem("savedCatIds")) 
            : [];
        
        if(savedCatIds.includes(id)){
            //new arr minus id
            const newArr = [...savedCatIds].filter(catId => catId !== id);
            sessionStorage.setItem("savedCatIds", JSON.stringify(newArr));

            //add to adopted array
            const newArr2 = [...adoptedCatIds, id];
            sessionStorage.setItem("adoptedCatIds", JSON.stringify(newArr2));

            unSelectFilter();
            alert(`Thank you for adopting ${name}!💕🐱`);
        }
    }

    return <div key={id} style={catObjStyle}>
        <img src={image} alt={`A picture of ${name}`} style={catImgStyle}/>
        <h2 style={nameStyle}>{name}</h2>
        
        <button onClick={unSelectCat} style={unSelectButtonStyle}>Unselect</button>
        <button onClick={adoptCat} style={adoptButtonStyle}>💕Adopt</button>

    </div>
}

export default BadgerBudSummary;