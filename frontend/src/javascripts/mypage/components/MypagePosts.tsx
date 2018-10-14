import * as React from 'react';
import { gon } from '../../types/window';
import NormalPosts from '../../shared/components/NormalPosts/NormalPosts';

const posts = gon.mypageKicksposts;
const logged_in = gon.logged_in;

class MypagePosts extends React.Component {
  render() {
    return <NormalPosts posts={posts} logged_in={logged_in} />;
  }
}

export default MypagePosts;
