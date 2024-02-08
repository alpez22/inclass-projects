import React from "react";
import { useState } from "react";
import Carousel from 'react-bootstrap/Carousel';

const BadgerBudSummary = ({id, imgIds, name, gender, breed, age, description, saveFilter}) => {

    const [showMore, setShowMore] = useState(false);

    const catObjStyle = {
        border: "1px solid",
        borderRadius: "10px",
        padding: "10px",
        margin: "10px",
        width: "350px"
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

    const showMoreButtonStyle = {
        backgroundColor: "#08c74b",
        marginLeft: "50px",
        borderRadius: "10px",
        padding: "7px",
    };

    const saveButtonStyle = {
        backgroundColor: "grey",
        color: "white",
        marginLeft: "1px",
        width: "29%", 
        borderRadius: "10px",
        padding: "7px",
    };

    const saveCat = () => {
        //if savedCatIds exists, set savedCatIds to the array version of the saved cats, else it doesn't exist
        const savedCatIds = sessionStorage.getItem("savedCatIds") 
            ? JSON.parse(sessionStorage.getItem("savedCatIds")) 
            : [];
        
        //update savedCatIds if this new cat isn't in the savedCatIds array
        if(!savedCatIds.includes(id)){

            const newArr = [...savedCatIds, id];
            sessionStorage.setItem("savedCatIds", JSON.stringify(newArr));
            saveFilter();
            alert(`${name} has been added to your basket!`);
        }
    }

return (<div key={id} style={catObjStyle}> 
    {showMore 
        ? (<Carousel> {imgIds.map((imgId, index) => 
            (<Carousel.Item key={index}> 
                <img 
                    src={`https://raw.githubusercontent.com/CS571-F23/hw5-api-static-content/main/cats/${imgId}`} 
                    alt={`A picture of ${name}`} 
                    style={catImgStyle} /> 
                </Carousel.Item> 
            ))}
        </Carousel> ) 
        : ( 
            <img src={`https://raw.githubusercontent.com/CS571-F23/hw5-api-static-content/main/cats/${imgIds[0]}`} 
                alt={`A picture of ${name}`} 
                style={catImgStyle} /> )
    } 
    <h2 style={nameStyle}>{name}</h2>
            
            {showMore ? (
                <div>
                    <p>{gender}</p>
                    <p>{breed}</p>
                    <p>{toAge(age)}</p>
                    <p>{description}</p>
                    <button onClick={() => setShowMore(false)} style={showMoreButtonStyle}>Show Less</button>
                    <button onClick={saveCat} style={saveButtonStyle}>🩷 Save</button>
                </div>
            ) : (
                <div>
                    <button onClick={() => setShowMore(true)} style={showMoreButtonStyle}>Show More</button>
                    <button onClick={saveCat} style={saveButtonStyle}>🩷 Save</button>
                </div>
            )}
    </div>)
}

export default BadgerBudSummary;

function toAge(age){
    const years = Math.floor(age / 12);
    const months = age % 12;
    if(age >= 12 && months === 0){
        return `${years} year(s) old`;
    }else if(age >= 12){
        return `${years} year(s) and ${months} month(s) old`;
    }else{
        return `${months} month(s) old`;
    }
}