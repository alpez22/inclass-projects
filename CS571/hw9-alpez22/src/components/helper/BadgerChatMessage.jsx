import { Text, TouchableOpacity, StyleSheet } from "react-native";
import BadgerCard from "./BadgerCard"

function BadgerChatMessage(props) {

    const dt = new Date(props.created);

    return <BadgerCard style={{ marginTop: 16, padding: 8, marginLeft: 8, marginRight: 8 }}>
        <Text style={{fontSize: 28, fontWeight: 600}}>{props.title}</Text>
        <Text style={{fontSize: 12}}>by {props.poster} | Posted on {dt.toLocaleDateString()} at {dt.toLocaleTimeString()}</Text>
        <Text></Text>
        <Text>{props.content}</Text>
        {props.showDeleteButton && (
                <TouchableOpacity onPress={props.onDelete} style={styles.deleteButton}>
                    <Text style={{color: "white"}}>Delete</Text>
                </TouchableOpacity>
            )}
    </BadgerCard>
}

const styles = StyleSheet.create({
    deleteButton: {
        backgroundColor: "crimson",
        padding: 10,
        margin: 10,
        alignItems: "center",
        borderRadius: 5
    }
});
export default BadgerChatMessage;