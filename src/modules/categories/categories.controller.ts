import { Controller, Get, Post, Body, Patch, Param, Delete, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto, UpdateCategoryDto } from './dto';

@ApiTags('Categories')
@Controller('categories')
export class CategoriesController {
    constructor(private readonly categoriesService: CategoriesService) { }

    @Post()
    @ApiOperation({ summary: 'Create a new category' })
    create(@Body() createCategoryDto: CreateCategoryDto) {
        return this.categoriesService.create(createCategoryDto);
    }

    @Get()
    @ApiOperation({ summary: 'Get all categories' })
    findAll() {
        return this.categoriesService.findAll();
    }

    @Get('roots')
    @ApiOperation({ summary: 'Get root categories' })
    findRoots() {
        return this.categoriesService.findRootCategories();
    }

    @Get(':id')
    @ApiOperation({ summary: 'Get category by ID' })
    findOne(@Param('id') id: string) {
        return this.categoriesService.findOne(id);
    }

    @Get(':id/subcategories')
    @ApiOperation({ summary: 'Get subcategories' })
    findSubcategories(@Param('id') id: string) {
        return this.categoriesService.findSubcategories(id);
    }

    @Patch(':id')
    @ApiOperation({ summary: 'Update category' })
    update(@Param('id') id: string, @Body() updateCategoryDto: UpdateCategoryDto) {
        return this.categoriesService.update(id, updateCategoryDto);
    }

    @Delete(':id')
    @HttpCode(HttpStatus.NO_CONTENT)
    @ApiOperation({ summary: 'Delete category' })
    remove(@Param('id') id: string) {
        return this.categoriesService.remove(id);
    }
}
