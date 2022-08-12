import * as React from "react"
import Wrapper from "../Wrappers/Wrapper";
import Operation from '../Wrappers/Operation';
import Text from '../../Entities/Text';

export default function Title(props: { title: any }) {
  if (!props.title) return;

  return (
    <Wrapper title='название'>
      {props.title.add && <Operation type='append'><Text title={props.title.add}></Text></Operation>}
      {props.title.remove && <Operation type='remove'><Text title={props.title.remove}></Text></Operation>}
    </Wrapper>
  )
}
