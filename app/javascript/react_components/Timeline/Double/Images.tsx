import * as React from "react"
import Wrapper from "../Wrappers/Wrapper";
import Operation from '../Wrappers/Operation';
import Image from '../../Entities/Image';

export default function Images(props: { images: any }) {
  if (!props.images) return;

  return (
    <Wrapper title='изображения'>
      {props.images.add && props.images.add.length > 0 &&
        props.images.add.map((image: any) => (
            <Operation type='append' key={image.id}>
              <Image image={image}></Image>
            </Operation>
        ))}
      {props.images.remove && props.images.remove.length > 0 &&
        props.images.remove.map((image: any) => (
          <Operation type='remove' key={image.id}>
            <Image image={image}></Image>
          </Operation>
        ))}
    </Wrapper>
  )
}
