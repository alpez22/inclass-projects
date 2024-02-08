const Student = (props) => {
    const { name, major, numCredits, fromWisconsin, interests } = props.data;

    return <div>
        <h2>{name.first} {name.last}</h2>
        <h4>{major}</h4>
        <p>credits: {numCredits}</p>
        <p>{name.first} is {fromWisconsin ? "from" : "not from"} Wisconsin </p>
        <p>{name.first} has {interests.length} Interests:</p>
        <ul>
            {interests.map((interest, index) => (
                <ul key={index}>- {interest}</ul>
            ))}
        </ul>
        
    </div>
}

export default Student;