export interface GonKickspost {
  id: number;
  user_id: number;
  brand: string | null;
  color: string | null;
  title: string;
  content: string | null;
  size: number;
  picture_url: string;
  postType: string;
  postUser: GonPostUser;
  goodNum: number;
  commentNum: number;
  isGood: boolean;
  isMyPost: boolean;
}

export interface GonPostUser {
  id: number;
  name: string;
  mysize_id: string;
  image_url: string;
  size: number;
  content: string;
}

export interface Gon {
  test: string;
  followingKicksposts: GonKickspost[];
  mypageKicksposts: GonKickspost[];
  latestKicksposts: GonKickspost[];
  searchKicksposts: GonKickspost[];
  logged_in: boolean;
}

export const gon: Gon = (window as any).gon;
