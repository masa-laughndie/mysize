import axios from '../../modules/Shared/apis/common/axios';

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

export const removeGoodList = async (goodId: number | null): Promise<any> => {
  if (typeof goodId == 'number') {
    await axios.delete(`/goods/${goodId}`).catch(value => console.log(value));
  }
};
