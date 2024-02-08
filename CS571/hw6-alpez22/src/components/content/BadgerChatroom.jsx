import React, { useEffect, useState, useContext } from "react"
import { Row, Col, Card, Pagination, Button, Form } from "react-bootstrap";
import BadgerMessage from "../content/BadgerMessage";
import BadgerLoginStatusContext from "../contexts/BadgerLoginStatusContext";

export default function BadgerChatroom(props) {

    const [messages, setMessages] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [loginStatus, setLoginStatus] = useContext(BadgerLoginStatusContext);
    const[title, setTitle] = useState("");
    const[content, setContent] = useState("");

    const loadMessages = () => {
        fetch(`https://cs571.org/api/f23/hw6/messages?chatroom=${props.name}&page=${currentPage}`, {
            headers: {
                "X-CS571-ID": CS571.getBadgerId()
            }
        }).then(res => res.json()).then(json => {
            setMessages(json.messages);
            console.log(currentPage);
        })
    };

    //post content
    const createPost = () => {
        if (!title || !content) {
            alert('You must provide both a title and content!');
            return;
        }

        fetch(`https://cs571.org/api/f23/hw6/messages?chatroom=${props.name}`, {
            method: 'POST',
            credentials: "include",
            headers: {
                "Content-Type": "application/json",
                "X-CS571-ID": "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49"
            },
            body: JSON.stringify({
                title: title,
                content: content
            })
        }).then(res => {
                if (res.status === 200) {
                    return res.json();
                } else {
                    throw new Error();
                }
            }).then(json => {
                console.log("Recieved back...");
                loadMessages();
                console.log("test " , json);
                alert('Successfully Posted!');
            }).catch(e => {
                alert(`An error occured while making the request: ${e.message}`)
            })
    }

    const handleDelete = (messageId) => {
        fetch(`https://cs571.org/api/f23/hw6/messages?id=${messageId}`, {
            method: 'DELETE',
            credentials: "include",
            headers: {
                "X-CS571-ID": CS571.getBadgerId()
            }
        })
            .then(res => {
                if (res.status === 200) {
                    alert('Successfully deleted the post!');
                    loadMessages();
                } else {
                    throw new Error('Failed to delete the post');
                }
            })
            .catch(e => {
                alert(`An error occured while making the request: ${e.message}`);
            });
    };

    // Why can't we just say []?
    // The BadgerChatroom doesn't unload/reload when switching
    // chatrooms, only its props change! Try it yourself.
    useEffect(loadMessages, [props, currentPage]);

    const pageNumbers = [1, 2, 3, 4];

    return <>
        <h1>{props.name} Chatroom</h1>
        {
            /* Allow an authenticated user to create a post. */
            loginStatus 
            ? 
            <>
            <Col>
                <Form.Label id="title" htmlFor="title">Post Title</Form.Label>
                <Form.Control type="text" value={title} onChange={(e) => setTitle(e.target.value)} id="title"></Form.Control>
                <Form.Label id="title" htmlFor="content">Post Content</Form.Label>
                <Form.Control  type="content" value={content} onChange={(e) => setContent(e.target.value)} id="content"></Form.Control>
                <br></br>
                <Button onClick={createPost}>Create Post</Button>
            </Col>
            </>
            : 
            <p>You must be logged in to post!</p>

        }
        <hr/>
        {
            messages.length > 0 ?
            <>
                <Row>
                    {
                        messages.map((message) => (
                            <Col key={message.id} xs={12} md={6} lg={4} xl={3} style={{ width: '400px', margin: '10px' }}>
                                <BadgerMessage
                                    title={message.title}
                                    poster={message.poster}
                                    content={message.content}
                                    created={message.created}
                                    id={message.id}
                                    delete={handleDelete}
                                />
                            </Col>
                        ))
                    }
                </Row>
                
            </>
                :
                <p>There are no messages on this page yet!</p>
        }
        <Pagination>
            {pageNumbers.map((number) => (
                    <Pagination.Item key={number} active={number === currentPage} onClick={() => setCurrentPage(number)}>
                        {number}
                    </Pagination.Item>
                ))}
        </Pagination>
    </>
}
