import axios from '../../Shared/apis/common/axios';

export const addGoodList = async (id: number, type: string): Promise<any> => {
  const formatPoatType = type.charAt(0).toUpperCase() + type.slice(1);
  const response = await axios
    .post('/goods.json', {
      post_id: id,
      post_type: formatPoatType
    })
    .catch(error => console.log(error));

  return response.data;
};
