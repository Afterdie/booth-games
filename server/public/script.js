const apiUrl = 'http://localhost:5001';

let voteCount = {
    left: 0,
    right: 0
}

function updateBars() {
    fetch(`${apiUrl}/api/get-votes`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        },
    })
        .then(response => response.json())
        .then(data => {
            let totalVotes = data.left + data.right;
            document.getElementById('leftBar').style.width = (data.left / totalVotes) * 100 + '%';
            document.getElementById('rightBar').style.width = (data.right / totalVotes) * 100 + '%';
        })
        .catch((error) => {
            console.error('Error:', error);
        });
}
updateBars();
setInterval(updateBars, 100);

window.onload = function () {

    document.getElementById('leftButton').addEventListener('click', function () {
        voteCount.left++;
        updateBars();
        sendLeft();
        console.log('Left Button has been clicked ' + voteCount.left + ' times');
    });

    document.getElementById('rightButton').addEventListener('click', function () {
        voteCount.right++;
        updateBars();
        sendRight();
        console.log('Right Button has been clicked ' + voteCount.right + ' times');
    });
}

function sendLeft() {
    // Send voteCount to API
    fetch(`${apiUrl}/api/vote`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ option: "Left" })
    })
        .then(response => response.json())
        .then(data => console.log(data))
        .catch((error) => {
            console.error('Error:', error);
        });
}

function sendRight() {
    // Send voteCount to API
    fetch(`${apiUrl}/api/vote`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ option: "Right" })
    })
        .then(response => response.json())
        .then(data => console.log(data))
        .catch((error) => {
            console.error('Error:', error);
        });
}
