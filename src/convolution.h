/****************************************************************************
Copyright (C) 2010 Laszlo Simon <laszlo.simon@gmail.com>

This file is part of the HidraVFX project.

HidraVFX is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

HidraVFX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with HidraVFX. If not, see <http://www.gnu.org/licenses/>.
****************************************************************************/

#ifndef CONVOLUTION_H_
#define CONVOLUTION_H_

extern double cmminifinger[], cmledge[], cmmedge[], cmhedge[], cmhorprewitt[],
              cmverprewitt[], cmhorsobel[], cmversobel[], cmgauss[], cmenhancededge[],
              cmendy[], cmenhancedfocus[], cmsharpen[], cmemboss1[], cmemboss2[], cmlsoften[],
              cmhsoften[], cmlblur[], cmmblur[], cmlabirintXS[], cmmsoften[], cmfinger[],
              cminstacfingerprint[], cmgaussM[], cmreducedjaggies[], cmpsychedelic[],
              cmlitograph[], cmlabirintS[], cmlabirintM[], cmlabirintL[], cmlabirintXL[],
              cmbasreliefHD[], cmbasreliefMD[], cmbasreliefLD[], cmpointilistic[];

extern double convolution(tLayerF src, int ix, int iy, int ch, double matrix[], int w, int h);

#endif
