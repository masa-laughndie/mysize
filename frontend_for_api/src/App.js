import React from 'react';
import './App.css';
import axios from './common/axios';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
        posts: [],
    }
  }

  componentDidMount() {
    axios.get('/api/v1/kicksposts')
      .then(results => {
        console.log(results);
        this.setState({
            posts: results.data
        });
      })
      .catch(data => {
          console.log(data);
      });
  }

  render() {
    return (
      <ul>
        { this.state.posts.map(post => <li>{post.title}:{post.content}</li>)}
      </ul>
    );
  }
}

export default App;
