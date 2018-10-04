import * as React from 'react';
import { GoodButton } from './GoodButton';
import { UngoodButton } from './UngoodButton';

const DummyGoodButton = () => {
  return (
    <div className="good-form">
      <div className="c form-good">
        <a className="ban" href="#">
          <i className="fa fa-thumbs-o-up" />
        </a>
      </div>
    </div>
  );
};

interface Props {
  logged_in: boolean;
  id: number;
  isGood: boolean;
}

class GoodForm extends React.Component<Props> {
  public render() {
    const { logged_in, id, isGood } = this.props;
    if (logged_in) {
      if (isGood) {
        return <UngoodButton id={id} />;
      } else {
        return <GoodButton id={id} />;
      }
    } else {
      return <DummyGoodButton />;
    }
  }
}

export default GoodForm;
